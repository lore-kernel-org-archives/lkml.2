Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2B1A1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:27:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49190 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab2B1A1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:27:43 -0500
Message-ID: <4F4C1F76.70403@zytor.com>
Date: Mon, 27 Feb 2012 16:27:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: linux-kernel@vger.kernel.org, Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
In-Reply-To: <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------040209050900080909070204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040209050900080909070204
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/27/2012 04:08 PM, Joshua C. wrote:
> 
> If so I'm not sure about it. We check the BIOS data area as defined
> for IBM PCs (1981), so a fair amount of user should benefit from the
> change. Those non-BIOS boots can set the numlock=0 and won't be
> affected by this. I think this isa lot easier to implement than doing
> it in the BIOS bootstrap code.
> 

Here is a patch to query the BIOS state properly; if you could fill out
the rest of the patch then we can merge this in easily enough.

	-hpa

--------------040209050900080909070204
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2Jvb3QvbWFpbi5jIGIvYXJjaC94ODYvYm9vdC9tYWlu
LmMKaW5kZXggNDAzNThjOC4uY2Y2MDgzZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvYm9vdC9t
YWluLmMKKysrIGIvYXJjaC94ODYvYm9vdC9tYWluLmMKQEAgLTU3LDE0ICs1NywyMCBAQCBz
dGF0aWMgdm9pZCBjb3B5X2Jvb3RfcGFyYW1zKHZvaWQpCiB9CiAKIC8qCi0gKiBTZXQgdGhl
IGtleWJvYXJkIHJlcGVhdCByYXRlIHRvIG1heGltdW0uICBVbmNsZWFyIHdoeSB0aGlzCisg
KiBRdWVyeSB0aGUga2V5Ym9hcmQgbG9jayBzdGF0dXMgYXMgZ2l2ZW4gYnkgdGhlIEJJT1Ms
IGFuZAorICogc2V0IHRoZSBrZXlib2FyZCByZXBlYXQgcmF0ZSB0byBtYXhpbXVtLiAgVW5j
bGVhciB3aHkgdGhlIGxhdHRlcgogICogaXMgZG9uZSBoZXJlOyB0aGlzIG1pZ2h0IGJlIHBv
c3NpYmxlIHRvIGtpbGwgb2ZmIGFzIHN0YWxlIGNvZGUuCiAgKi8KLXN0YXRpYyB2b2lkIGtl
eWJvYXJkX3NldF9yZXBlYXQodm9pZCkKK3N0YXRpYyB2b2lkIGtleWJvYXJkX2luaXQodm9p
ZCkKIHsKLQlzdHJ1Y3QgYmlvc3JlZ3MgaXJlZzsKKwlzdHJ1Y3QgYmlvc3JlZ3MgaXJlZywg
b3JlZzsKIAlpbml0cmVncygmaXJlZyk7Ci0JaXJlZy5heCA9IDB4MDMwNTsKKworCWlyZWcu
YWggPSAweDAyOwkJLyogR2V0IGtleWJvYXJkIHN0YXR1cyAqLworCWludGNhbGwoMHgxNiwg
JmlyZWcsICZvcmVnKTsKKwlib290X3BhcmFtcy5rYmRfc3RhdHVzID0gb3JlZy5hbDsKKwor
CWlyZWcuYXggPSAweDAzMDU7CS8qIFNldCBrZXlib2FyZCByZXBlYXQgcmF0ZSAqLwogCWlu
dGNhbGwoMHgxNiwgJmlyZWcsIE5VTEwpOwogfQogCkBAIC0xNTEsOCArMTU3LDggQEAgdm9p
ZCBtYWluKHZvaWQpCiAJLyogRGV0ZWN0IG1lbW9yeSBsYXlvdXQgKi8KIAlkZXRlY3RfbWVt
b3J5KCk7CiAKLQkvKiBTZXQga2V5Ym9hcmQgcmVwZWF0IHJhdGUgKHdoeT8pICovCi0Ja2V5
Ym9hcmRfc2V0X3JlcGVhdCgpOworCS8qIFNldCBrZXlib2FyZCByZXBlYXQgcmF0ZSAod2h5
PykgYW5kIHF1ZXJ5IHRoZSBsb2NrIGZsYWdzICovCisJa2V5Ym9hcmRfaW5pdCgpOwogCiAJ
LyogUXVlcnkgTUNBIGluZm9ybWF0aW9uICovCiAJcXVlcnlfbWNhKCk7CmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ib290cGFyYW0uaCBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2Jvb3RwYXJhbS5oCmluZGV4IDJmOTBjNTEuLmViNDVhYTYgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2Jvb3RwYXJhbS5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2Jvb3RwYXJhbS5oCkBAIC0xMTIsNyArMTEyLDggQEAgc3RydWN0IGJvb3RfcGFyYW1z
IHsKIAlfX3U4ICBlODIwX2VudHJpZXM7CQkJCS8qIDB4MWU4ICovCiAJX191OCAgZWRkYnVm
X2VudHJpZXM7CQkJCS8qIDB4MWU5ICovCiAJX191OCAgZWRkX21icl9zaWdfYnVmX2VudHJp
ZXM7CQkJLyogMHgxZWEgKi8KLQlfX3U4ICBfcGFkNls2XTsJCQkJCS8qIDB4MWViICovCisJ
X191OCAga2JkX3N0YXR1czsJCQkJLyogMHgxZWIgKi8KKwlfX3U4ICBfcGFkNls1XTsJCQkJ
CS8qIDB4MWVjICovCiAJc3RydWN0IHNldHVwX2hlYWRlciBoZHI7ICAgIC8qIHNldHVwIGhl
YWRlciAqLwkvKiAweDFmMSAqLwogCV9fdTggIF9wYWQ3WzB4MjkwLTB4MWYxLXNpemVvZihz
dHJ1Y3Qgc2V0dXBfaGVhZGVyKV07CiAJX191MzIgZWRkX21icl9zaWdfYnVmZmVyW0VERF9N
QlJfU0lHX01BWF07CS8qIDB4MjkwICovCg==
--------------040209050900080909070204--
