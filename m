Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab0D1XPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:15:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:17680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab0D1XO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,290,1270450800"; 
   d="scan'208,223";a="562499489"
From: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Apr 2010 16:10:40 -0700
Subject: [RFC PATCH 2/4] Mobile security processor driver
Thread-Topic: [RFC PATCH 2/4] Mobile security processor driver
Thread-Index: AcrnHQ5GMkMejPQBSYeqq/tzWgIhEAACrb7w
Message-ID: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AD@orsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ADorsmsx501amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ADorsmsx501amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 65abe47530522e97908aac282820243798721c54 Mon Sep 17 00:00:00 2001
From: Mark Allyn <mark.a.allyn@intel.com>
Date: Wed, 28 Apr 2010 14:35:43 -0700
Subject: RFC [PATCH 2/4] staging: sep: update Makefile and provide explanat=
ion in Kconfig

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
  drivers/staging/sep/Kconfig  |   11 ++++++-----
  drivers/staging/sep/Makefile |    3 ++-
  2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 0a9c39c..f78abe3 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -1,10 +1,11 @@
  config DX_SEP
-       tristate "Discretix SEP driver"
-#      depends on MRST
-       depends on RAR_REGISTER && PCI
-       default y
+       tristate "SEP driver"
+       default n
        help
-         Discretix SEP driver
+         SEP driver

+         The is the driver for the Intel mobile platform's
+         security processor (SEP), which performs encryption
+         using dedicated hardware.
          If unsure say M. The compiled module will be
          called sep_driver.ko
diff --git a/drivers/staging/sep/Makefile b/drivers/staging/sep/Makefile
index 628d5f9..551db4b 100644
--- a/drivers/staging/sep/Makefile
+++ b/drivers/staging/sep/Makefile
@@ -1,2 +1,3 @@
+EXTRA_CFLAGS +=3D -DDX_CC5_SEP_PLAT -DDX_RAR_SUPPORT -DCRYS_NO_EXT_IF_MODE=
_SUPPORT
  obj-$(CONFIG_DX_SEP) :=3D sep_driver.o
-
+sep_driver-objs :=3D sep_main_mod.o sep_ext_with_pci_driver.o
--
1.6.0.4

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ADorsmsx501amrc_
Content-Type: text/x-diff;
	name="0002-staging-sep-update-Makefile-and-provide-explanatio.patch"
Content-Description: 0002-staging-sep-update-Makefile-and-provide-explanatio.patch
Content-Disposition: attachment;
	filename="0002-staging-sep-update-Makefile-and-provide-explanatio.patch";
	size=1469; creation-date="Wed, 28 Apr 2010 14:52:11 GMT";
	modification-date="Wed, 28 Apr 2010 14:52:11 GMT"
Content-ID: <alpine.DEB.2.00.1004281450340.24448@localhost.localdomain>
Content-Transfer-Encoding: base64

RnJvbSA2NWFiZTQ3NTMwNTIyZTk3OTA4YWFjMjgyODIwMjQzNzk4NzIxYzU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTWFyayBBbGx5biA8bWFyay5hLmFsbHluQGludGVsLmNvbT4N
CkRhdGU6IFdlZCwgMjggQXByIDIwMTAgMTQ6MzU6NDMgLTA3MDANClN1YmplY3Q6IFJGQyBbUEFU
Q0ggMi80XSBzdGFnaW5nOiBzZXA6IHVwZGF0ZSBNYWtlZmlsZSBhbmQgcHJvdmlkZSBleHBsYW5h
dGlvbiBpbiBLY29uZmlnDQoNClNpZ25lZC1vZmYtYnk6IE1hcmsgQS4gQWxseW4gPG1hcmsuYS5h
bGx5bkBpbnRlbC5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvc2VwL0tjb25maWcgIHwgICAx
MSArKysrKystLS0tLQ0KIGRyaXZlcnMvc3RhZ2luZy9zZXAvTWFrZWZpbGUgfCAgICAzICsrLQ0K
IDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3NlcC9LY29uZmlnIGIvZHJpdmVycy9zdGFnaW5nL3Nl
cC9LY29uZmlnDQppbmRleCAwYTljMzljLi5mNzhhYmUzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3NlcC9LY29uZmlnDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvc2VwL0tjb25maWcNCkBA
IC0xLDEwICsxLDExIEBADQogY29uZmlnIERYX1NFUA0KLQl0cmlzdGF0ZSAiRGlzY3JldGl4IFNF
UCBkcml2ZXIiDQotIwlkZXBlbmRzIG9uIE1SU1QNCi0JZGVwZW5kcyBvbiBSQVJfUkVHSVNURVIg
JiYgUENJDQotCWRlZmF1bHQgeQ0KKwl0cmlzdGF0ZSAiU0VQIGRyaXZlciINCisJZGVmYXVsdCBu
DQogCWhlbHANCi0JICBEaXNjcmV0aXggU0VQIGRyaXZlcg0KKwkgIFNFUCBkcml2ZXINCiANCisJ
ICBUaGUgaXMgdGhlIGRyaXZlciBmb3IgdGhlIEludGVsIG1vYmlsZSBwbGF0Zm9ybSdzDQorCSAg
c2VjdXJpdHkgcHJvY2Vzc29yIChTRVApLCB3aGljaCBwZXJmb3JtcyBlbmNyeXB0aW9uDQorCSAg
dXNpbmcgZGVkaWNhdGVkIGhhcmR3YXJlLg0KIAkgIElmIHVuc3VyZSBzYXkgTS4gVGhlIGNvbXBp
bGVkIG1vZHVsZSB3aWxsIGJlDQogCSAgY2FsbGVkIHNlcF9kcml2ZXIua28NCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvc2VwL01ha2VmaWxlIGIvZHJpdmVycy9zdGFnaW5nL3NlcC9NYWtl
ZmlsZQ0KaW5kZXggNjI4ZDVmOS4uNTUxZGI0YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy9zZXAvTWFrZWZpbGUNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9zZXAvTWFrZWZpbGUNCkBAIC0x
LDIgKzEsMyBAQA0KK0VYVFJBX0NGTEFHUyArPSAtRERYX0NDNV9TRVBfUExBVCAtRERYX1JBUl9T
VVBQT1JUIC1EQ1JZU19OT19FWFRfSUZfTU9ERV9TVVBQT1JUDQogb2JqLSQoQ09ORklHX0RYX1NF
UCkgOj0gc2VwX2RyaXZlci5vDQotDQorc2VwX2RyaXZlci1vYmpzIDo9IHNlcF9tYWluX21vZC5v
IHNlcF9leHRfd2l0aF9wY2lfZHJpdmVyLm8NCi0tIA0KMS42LjAuNA0KDQo=

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ADorsmsx501amrc_--
