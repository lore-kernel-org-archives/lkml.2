Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0D1XPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:15:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:34986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab0D1XPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,290,1270450800"; 
   d="scan'208,223";a="562499491"
From: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Apr 2010 16:10:52 -0700
Subject: [RFC PATCH 4/4] Mobile security processor driver
Thread-Topic: [RFC PATCH 4/4] Mobile security processor driver
Thread-Index: AcrnHVwIhkdtDjX8Ql6ISzlPT+b78AACnB3g
Message-ID: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AF@orsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AForsmsx501amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AForsmsx501amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 9230c90ce19747554354c9fc93b3b1c8e661894c Mon Sep 17 00:00:00 2001
From: Mark Allyn <mark.a.allyn@intel.com>
Date: Wed, 28 Apr 2010 14:41:39 -0700
Subject: RFC [PATCH 4/4] staging: sep: Update TODO

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
  drivers/staging/sep/TODO |   36 ++++++++++++++++++++++++++++--------
  1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sep/TODO b/drivers/staging/sep/TODO
index ff0e931..1a8f876 100644
--- a/drivers/staging/sep/TODO
+++ b/drivers/staging/sep/TODO
@@ -1,8 +1,28 @@
-Todo's so far (from Alan Cox)
-- Fix firmware loading
-- Get firmware into firmware git tree
-- Review and tidy each algorithm function
-- Check whether it can be plugged into any of the kernel crypto API
-  interfaces
-- Do something about the magic shared memory interface and replace it
-  with something saner (in Linux terms)
+Todo's so far (from Mark Allyn)
+
+- Resolve issue wiht allowing user space software to handle
+  physical addresses
+
+- Determine device types at runtime
+
+- Ensure that all global variables be either static or be in a global stru=
cture;
+  preferably in structure
+
+- Fix formatting (it did pass checkpatch, but it's still awkward
+
+- Fix problems in singleton opens
+
+- Provide documentation on mutex, test and set, and other locking
+
+- Fix process exit logic in caller ID handler
+
+- Need to unmap memory in case of failure
+
+- Need to document errors
+
+- Fix the way the device is set up; let the probe do the stuff such as
+  registering the device with the driver
+
+- Use cpu_to_le or cpu_to_bt instead of SEP_CHANGE_ENDIANNES
+
+- Don't use 32 bit values for virtual addresses
--
1.6.0.4

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AForsmsx501amrc_
Content-Type: text/x-diff; name="0004-staging-sep-Update-TODO.patch"
Content-Description: 0004-staging-sep-Update-TODO.patch
Content-Disposition: attachment;
	filename="0004-staging-sep-Update-TODO.patch"; size=1752;
	creation-date="Wed, 28 Apr 2010 14:54:21 GMT";
	modification-date="Wed, 28 Apr 2010 14:54:21 GMT"
Content-ID: <alpine.DEB.2.00.1004281452430.24448@localhost.localdomain>
Content-Transfer-Encoding: base64

RnJvbSA5MjMwYzkwY2UxOTc0NzU1NDM1NGM5ZmM5M2IzYjFjOGU2NjE4OTRjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTWFyayBBbGx5biA8bWFyay5hLmFsbHluQGludGVsLmNvbT4N
CkRhdGU6IFdlZCwgMjggQXByIDIwMTAgMTQ6NDE6MzkgLTA3MDANClN1YmplY3Q6IFJGQyBbUEFU
Q0ggNC80XSBzdGFnaW5nOiBzZXA6IFVwZGF0ZSBUT0RPDQoNClNpZ25lZC1vZmYtYnk6IE1hcmsg
QS4gQWxseW4gPG1hcmsuYS5hbGx5bkBpbnRlbC5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcv
c2VwL1RPRE8gfCAgIDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQ0KIDEg
ZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9zZXAvVE9ETyBiL2RyaXZlcnMvc3RhZ2luZy9zZXAvVE9E
Tw0KaW5kZXggZmYwZTkzMS4uMWE4Zjg3NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9z
ZXAvVE9ETw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3NlcC9UT0RPDQpAQCAtMSw4ICsxLDI4IEBA
DQotVG9kbydzIHNvIGZhciAoZnJvbSBBbGFuIENveCkNCi0tIEZpeCBmaXJtd2FyZSBsb2FkaW5n
DQotLSBHZXQgZmlybXdhcmUgaW50byBmaXJtd2FyZSBnaXQgdHJlZQ0KLS0gUmV2aWV3IGFuZCB0
aWR5IGVhY2ggYWxnb3JpdGhtIGZ1bmN0aW9uDQotLSBDaGVjayB3aGV0aGVyIGl0IGNhbiBiZSBw
bHVnZ2VkIGludG8gYW55IG9mIHRoZSBrZXJuZWwgY3J5cHRvIEFQSQ0KLSAgaW50ZXJmYWNlcw0K
LS0gRG8gc29tZXRoaW5nIGFib3V0IHRoZSBtYWdpYyBzaGFyZWQgbWVtb3J5IGludGVyZmFjZSBh
bmQgcmVwbGFjZSBpdA0KLSAgd2l0aCBzb21ldGhpbmcgc2FuZXIgKGluIExpbnV4IHRlcm1zKQ0K
K1RvZG8ncyBzbyBmYXIgKGZyb20gTWFyayBBbGx5bikNCisNCistIFJlc29sdmUgaXNzdWUgd2lo
dCBhbGxvd2luZyB1c2VyIHNwYWNlIHNvZnR3YXJlIHRvIGhhbmRsZQ0KKyAgcGh5c2ljYWwgYWRk
cmVzc2VzDQorDQorLSBEZXRlcm1pbmUgZGV2aWNlIHR5cGVzIGF0IHJ1bnRpbWUNCisNCistIEVu
c3VyZSB0aGF0IGFsbCBnbG9iYWwgdmFyaWFibGVzIGJlIGVpdGhlciBzdGF0aWMgb3IgYmUgaW4g
YSBnbG9iYWwgc3RydWN0dXJlOw0KKyAgcHJlZmVyYWJseSBpbiBzdHJ1Y3R1cmUNCisNCistIEZp
eCBmb3JtYXR0aW5nIChpdCBkaWQgcGFzcyBjaGVja3BhdGNoLCBidXQgaXQncyBzdGlsbCBhd2t3
YXJkDQorDQorLSBGaXggcHJvYmxlbXMgaW4gc2luZ2xldG9uIG9wZW5zDQorDQorLSBQcm92aWRl
IGRvY3VtZW50YXRpb24gb24gbXV0ZXgsIHRlc3QgYW5kIHNldCwgYW5kIG90aGVyIGxvY2tpbmcN
CisNCistIEZpeCBwcm9jZXNzIGV4aXQgbG9naWMgaW4gY2FsbGVyIElEIGhhbmRsZXINCisNCist
IE5lZWQgdG8gdW5tYXAgbWVtb3J5IGluIGNhc2Ugb2YgZmFpbHVyZQ0KKw0KKy0gTmVlZCB0byBk
b2N1bWVudCBlcnJvcnMNCisNCistIEZpeCB0aGUgd2F5IHRoZSBkZXZpY2UgaXMgc2V0IHVwOyBs
ZXQgdGhlIHByb2JlIGRvIHRoZSBzdHVmZiBzdWNoIGFzDQorICByZWdpc3RlcmluZyB0aGUgZGV2
aWNlIHdpdGggdGhlIGRyaXZlcg0KKw0KKy0gVXNlIGNwdV90b19sZSBvciBjcHVfdG9fYnQgaW5z
dGVhZCBvZiBTRVBfQ0hBTkdFX0VORElBTk5FUw0KKw0KKy0gRG9uJ3QgdXNlIDMyIGJpdCB2YWx1
ZXMgZm9yIHZpcnR1YWwgYWRkcmVzc2VzDQotLSANCjEuNi4wLjQNCg0K

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AForsmsx501amrc_--
