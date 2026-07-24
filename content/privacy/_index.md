---
title: "k Privacy Notice"
date: 2026-07-24
draft: false
type: "page"
url: "/privacy/"
---

**Effective date:** July 24, 2026

This notice describes how **k**, a private household web application operated by Dragos Hont, handles personal information when you sign in, register, pair a browser, or use Login with Amazon.

## Information k receives

When you sign in through the configured identity service, k may receive:

- a stable identity-provider identifier used to recognize your account;
- your display name and email address, when the identity provider supplies them;
- security and operational information such as sign-in time, paired-device label and type, session state, and request identifiers;
- settings you choose to provide, such as an optional Kindle delivery address.

PINs are never stored in plain text. Authentication tokens, cookies, PINs, QR secrets, and provider credentials are not written to diagnostic logs.

## Login with Amazon

Login with Amazon is used for **identity authentication only**. k does not use Login with Amazon to access your Amazon purchases, Kindle library, Kindle Unlimited membership, reading activity, payment information, or Send to Kindle content.

Amazon processes the sign-in under its own privacy notice. k receives only the identity information authorized by the requested sign-in scope and discards temporary broker tokens after the validated identity response is consumed.

## How information is used

k uses this information only to:

- create or open your k account after authentication;
- pair and manage browsers that may access your account;
- protect account changes and diagnose failed sign-in or pairing requests;
- provide features you explicitly configure, such as preparing a book for your device.

k does not sell personal information, use it for advertising, or share it with data brokers.

## Storage and retention

k runs on a privately operated homelab. Account identity and paired-device records are retained while the account is active. Short-lived pairing and sign-in transactions normally expire after ten minutes. Prepared files normally expire after 24 hours. Redacted security and operation records are normally retained for up to 90 days.

Some limited records may be retained longer when necessary to maintain security, prevent replay or abuse, or comply with applicable legal obligations.

## Cookies

k uses secure first-party cookies that are necessary for pairing, CSRF protection, device recognition, and authenticated sessions. k does not use third-party advertising cookies.

The website hosting this notice uses standard hosting telemetry and may use Google Analytics for aggregate website traffic measurement. That analytics service is separate from k account authentication.

## Service providers

Information may be processed by:

- the configured Authentik identity broker;
- Amazon, when you choose Login with Amazon;
- the privately operated infrastructure that hosts k;
- infrastructure providers necessary to serve this public notice.

These services are used only to provide authentication, hosting, security, and operation of the requested service.

## Access, correction, and deletion

You may request access, correction, or deletion of your k account information. Deleting an account revokes its paired devices and active sessions; limited redacted security records may remain for the retention period described above.

To make a privacy request, contact Dragos Hont through one of the contact channels linked on the [About page](/about/). Do not include passwords, PINs, authentication tokens, or client secrets in your message.

## Security

k uses HTTPS, short-lived authorization transactions, PKCE, signed and secure cookies, CSRF protection, encrypted provider credentials, least-privilege service identities, and restricted network access. No system can guarantee absolute security, but access is limited to what is required for the service.

## Changes

This notice may be updated when k's identity or data-handling behavior changes. The effective date above identifies the current version.
