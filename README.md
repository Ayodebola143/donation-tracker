A Clarity smart contract for tracking STX donations per user and allowing the contract owner to withdraw funds. Built for the Stacks blockchain.

---

## 📜 Contract Overview

- **Filename:** `donation-tracker.clar`
- **Language:** Clarity (Stacks blockchain smart contract language)
- **Purpose:** 
  - Accepts STX donations from users.
  - Tracks donation amounts per principal.
  - Allows only the contract owner to withdraw funds.
  - Provides read-only functions to query donation data.

---

## 🚀 Features

- ✅ Users can donate STX via the `donate` function.
- 📊 Keeps track of:
  - Total donated per principal (user).
  - Total donated to the contract overall.
- 🔐 Owner-only withdrawals with safety checks.
- 📤 Read-only accessors for analytics and transparency.

---

## 🔧 Functions

### 🟢 `donate (amount uint)`
Allows any user to donate a specified amount of STX to the contract.

- Transfers STX from sender to the contract.
- Updates:
  - User's total donated.
  - Contract-wide total donations.
- Emits a `print` log with donation details.

#### Example:

(donate u1000000) ;; Donates 1 STX
🔒 withdraw (amount uint) (recipient principal)
Allows only the contract owner to withdraw STX from the contract.

Validates:

Caller is the contract owner.

Contract has sufficient funds.

Transfers STX to the specified recipient.

Emits a print log with withdrawal details.

Example:

(withdraw u500000 (some-principal)) ;; Withdraws 0.5 STX to recipient
📖 get-total-donated (donor principal)
Returns the total amount donated by a given principal.

Example:

(get-total-donated 'SP123...abc) ;; => (ok u1000000)
📖 get-total-donations
Returns the total amount of STX donated to the contract.

Example:
(get-total-donations) ;; => (ok u5000000)
⚠️ Error Codes
Code	Description
u100	Not authorized (non-owner withdrawal)
u101	Insufficient funds in contract

🛡️ Security Notes
All withdrawals are restricted to the contract owner.

Transfer attempts beyond the contract balance are blocked.

Uses asserts! and try! for error handling and safety.

Copy code
clarinet deploy donation-tracker
