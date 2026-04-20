# Chapter 1: The Automation Mindset

This directory contains the foundational scripts discussed in Part I of **PowerShell Automation for Windows Administration**. The objective of this chapter is to transition from tactical scripting to resilient infrastructure engineering.

## Included Scripts

### Initialize-LabEnvironment.ps1
**Purpose:** An idempotent script designed to provision a Hyper-V internal switch and a base virtual machine (`TP-Lab-DC01`).
* **Technical Requirement:** Must be executed from an Elevated (Administrator) PowerShell session.
* **Core Principle:** Idempotency—the script verifies the state of the environment before attempting to create or modify resources.

---

## Technical Guidance

> [!TIP]
> **Operational Safety with -WhatIf**
> It is a best practice to utilize the `-WhatIf` parameter when executing scripts that perform destructive actions or modify system state. This allows for a dry-run to verify the intended outcome before any changes are committed to the environment.

> [!WARNING]
> **Privilege Requirements**
> Infrastructure automation frequently requires local administrative privileges. If "Access Denied" exceptions are encountered, verify that the host terminal is running with elevated permissions.

---

## Architectural Concepts Applied
* **Idempotency:** Designing logic that can be executed repeatedly without causing side effects or errors.
* **Environmental Consistency:** Utilizing standardized naming conventions to ensure predictable lab deployments.
* **State Verification:** Implementing pre-flight checks to confirm the existing system configuration before proceeding with provisioning.
