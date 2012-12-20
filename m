Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2LTCOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 21:14:05 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:47408 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTCN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 21:13:58 -0500
MIME-Version: 1.0
Date: Thu, 20 Dec 2012 10:13:57 +0800
Message-ID: <CABawtvNQCD5ikpCVMW2=yJwT2x7YX4v_Bwr_HyjdVZfi_TTeTg@mail.gmail.com>
Subject: [PATCH] arch/x86/pci/xen.c: fix a typo in comments
From: Ethan Zhao <ethan.kernel@gmail.com>
To: konrad.wilk@oracle.com, hap9@epoch.ncsc.mil
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf307f32b08d5e5804d13f48e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf307f32b08d5e5804d13f48e5
Content-Type: text/plain; charset=ISO-8859-1

Konrad,
      This patch fix a typo in comments of arch/x86/pci/xen.c

Thanks,
Ethan.zhao@oracle.com

---------------------------------------
commit 333a48b76d5311ae370d65dfac293ca0d839c455
Author: ethan.zhao <ethan.kernel@gmail.com>
Date:   Thu Dec 20 20:23:31 2012 -0800

    Fix a typo in comments

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 56ab749..8de6ced 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -2,7 +2,7 @@
  * Xen PCI - handle PCI (INTx) and MSI infrastructure calls for PV, HVM and
  * initial domain support. We also handle the DSDT _PRT callbacks for GSI's
  * used in HVM and initial domain mode (PV does not parse ACPI, so it has no
- * concept of GSIs). Under PV we hook under the pnbbios API for IRQs and
+ * concept of GSIs). Under PV we hook under the pnpbios API for IRQs and
  * 0xcf8 PCI configuration read/write.
  *
  *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>

--20cf307f32b08d5e5804d13f48e5
Content-Type: application/octet-stream; 
	name="1264-Fix-a-typo-in-comments.patch"
Content-Disposition: attachment; 
	filename="1264-Fix-a-typo-in-comments.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hax9aw850

RnJvbSAzMzNhNDhiNzZkNTMxMWFlMzcwZDY1ZGZhYzI5M2NhMGQ4MzljNDU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBldGhhbi56aGFvIDxldGhhbi5rZXJuZWxAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDIwIERlYyAyMDEyIDIwOjIzOjMxIC0wODAwClN1YmplY3Q6IFtQQVRDSCAxMjY0
LzEyNjRdIEZpeCBhIHR5cG8gaW4gY29tbWVudHMKCgpTaWduZWQtb2ZmLWJ5OiBldGhhbi56aGFv
IDxldGhhbi5rZXJuZWxAZ21haWwuY29tPgotLS0KIGFyY2gveDg2L3BjaS94ZW4uYyB8ICAgIDIg
Ky0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L3BjaS94ZW4uYyBiL2FyY2gveDg2L3BjaS94ZW4uYwppbmRleCA1
NmFiNzQ5Li44ZGU2Y2VkIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9wY2kveGVuLmMKKysrIGIvYXJj
aC94ODYvcGNpL3hlbi5jCkBAIC0yLDcgKzIsNyBAQAogICogWGVuIFBDSSAtIGhhbmRsZSBQQ0kg
KElOVHgpIGFuZCBNU0kgaW5mcmFzdHJ1Y3R1cmUgY2FsbHMgZm9yIFBWLCBIVk0gYW5kCiAgKiBp
bml0aWFsIGRvbWFpbiBzdXBwb3J0LiBXZSBhbHNvIGhhbmRsZSB0aGUgRFNEVCBfUFJUIGNhbGxi
YWNrcyBmb3IgR1NJJ3MKICAqIHVzZWQgaW4gSFZNIGFuZCBpbml0aWFsIGRvbWFpbiBtb2RlIChQ
ViBkb2VzIG5vdCBwYXJzZSBBQ1BJLCBzbyBpdCBoYXMgbm8KLSAqIGNvbmNlcHQgb2YgR1NJcyku
IFVuZGVyIFBWIHdlIGhvb2sgdW5kZXIgdGhlIHBuYmJpb3MgQVBJIGZvciBJUlFzIGFuZAorICog
Y29uY2VwdCBvZiBHU0lzKS4gVW5kZXIgUFYgd2UgaG9vayB1bmRlciB0aGUgcG5wYmlvcyBBUEkg
Zm9yIElSUXMgYW5kCiAgKiAweGNmOCBQQ0kgY29uZmlndXJhdGlvbiByZWFkL3dyaXRlLgogICoK
ICAqICAgQXV0aG9yOiBSeWFuIFdpbHNvbiA8aGFwOUBlcG9jaC5uY3NjLm1pbD4KLS0gCjEuNy4x
Cgo=
--20cf307f32b08d5e5804d13f48e5--
