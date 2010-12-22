Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0LVHjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:39:00 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60637 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0LVHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=c9f1cEg9MiKgUC0FxFCjI/gciBaP/P8k7dTYqcX8MbhY5aG0JWDeXq9+f3+BgPKQOS
         VqyZCLGbiLoylyr9VFJDP2xQAMy7xxUHA3wiWAhAj50hZjI9cAfk7B8LPb7m3HfdfJkt
         B2f3xDnf262kvU5cRly3XOGMAmBvSNCSnIe3Q=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 22 Dec 2010 08:38:57 +0100
Message-ID: <AANLkTik7SQ76zcAMk5=mgKRF7MWghVHhLtY1CtK-WPKy@mail.gmail.com>
Subject: [PATCH] drm/radeon: Remove DRIVER_DATE for UMS and KMS
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: DRI <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364ed8688f76030497fad8f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364ed8688f76030497fad8f9
Content-Type: text/plain; charset=UTF-8

Hi,

sorry, I still haven't setup a git-send-mail, thus sending the
old-fashioned way as attached patch.
This patch (against linux-next) is overdue.

"DRIVER_DATE is not maintained or upgraded on changes.

Furthermore, one DRIVER_DATE for UMS and KMS makes no sense.
It is enough to bump {KMS_}DRIVER_MAJOR, {KMS_}DRIVER_MINOR and
{KMS_}DRIVER_PATCHLEVEL defines."

Regards,
- Sedat -

--0016364ed8688f76030497fad8f9
Content-Type: plain/text; 
	name="0001-drm-radeon-Remove-DRIVER_DATE-for-UMS-and-KMS.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-Remove-DRIVER_DATE-for-UMS-and-KMS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghzwtvgg0

RnJvbSA3NDYzNzA4ZTY3NGUwMWU0M2JkOTIyMTg3NGVhNTdjODQ2NDM1Yjg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDIyIERlYyAyMDEwIDA4OjIzOjE2ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gZHJt
L3JhZGVvbjogUmVtb3ZlIERSSVZFUl9EQVRFIGZvciBVTVMgYW5kIEtNUwoKRFJJVkVSX0RBVEUg
aXMgbm90IG1haW50YWluZWQgb3IgdXBncmFkZWQgb24gY2hhbmdlcy4KCkZ1cnRoZXJtb3JlLCBv
bmUgRFJJVkVSX0RBVEUgZm9yIFVNUyBhbmQgS01TIG1ha2VzIG5vIHNlbnNlLgpJdCBpcyBlbm91
Z2ggdG8gYnVtcCB7S01TX31EUklWRVJfTUFKT1IsIHtLTVNffURSSVZFUl9NSU5PUiBhbmQKe0tN
U199RFJJVkVSX1BBVENITEVWRUwgZGVmaW5lcy4KClNpZ25lZC1vZmYtYnk6IFNlZGF0IERpbGVr
IDxzZWRhdC5kaWxla0BnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRl
b25fZHJ2LmMgfCAgICAyIC0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuaCB8
ICAgIDEgLQogMiBmaWxlcyBjaGFuZ2VkLCAwIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZHJ2LmMgYi9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuYwppbmRleCBhOTJkMmE1Li4xZjZmODRlIDEw
MDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuYworKysgYi9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuYwpAQCAtMjMxLDcgKzIzMSw2IEBAIHN0YXRp
YyBzdHJ1Y3QgZHJtX2RyaXZlciBkcml2ZXJfb2xkID0gewogCiAJLm5hbWUgPSBEUklWRVJfTkFN
RSwKIAkuZGVzYyA9IERSSVZFUl9ERVNDLAotCS5kYXRlID0gRFJJVkVSX0RBVEUsCiAJLm1ham9y
ID0gRFJJVkVSX01BSk9SLAogCS5taW5vciA9IERSSVZFUl9NSU5PUiwKIAkucGF0Y2hsZXZlbCA9
IERSSVZFUl9QQVRDSExFVkVMLApAQCAtMzI0LDcgKzMyMyw2IEBAIHN0YXRpYyBzdHJ1Y3QgZHJt
X2RyaXZlciBrbXNfZHJpdmVyID0gewogCiAJLm5hbWUgPSBEUklWRVJfTkFNRSwKIAkuZGVzYyA9
IERSSVZFUl9ERVNDLAotCS5kYXRlID0gRFJJVkVSX0RBVEUsCiAJLm1ham9yID0gS01TX0RSSVZF
Ul9NQUpPUiwKIAkubWlub3IgPSBLTVNfRFJJVkVSX01JTk9SLAogCS5wYXRjaGxldmVsID0gS01T
X0RSSVZFUl9QQVRDSExFVkVMLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
YWRlb25fZHJ2LmggYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuaAppbmRleCA0
NDhlYmE4Li5kZTJkZDc4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVv
bl9kcnYuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuaApAQCAtNDMs
NyArNDMsNiBAQAogCiAjZGVmaW5lIERSSVZFUl9OQU1FCQkicmFkZW9uIgogI2RlZmluZSBEUklW
RVJfREVTQwkJIkFUSSBSYWRlb24iCi0jZGVmaW5lIERSSVZFUl9EQVRFCQkiMjAwODA1MjgiCiAK
IC8qIEludGVyZmFjZSBoaXN0b3J5OgogICoKLS0gCjEuNy4yLjMKCg==
--0016364ed8688f76030497fad8f9--
