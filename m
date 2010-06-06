Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0FFJEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:04:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57614 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0FFJEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ADFWXvuXCKmkWpLPO9NmBbJ9i4ik3HQCd3l7fTXlQ5FzifNgddrwp/WJLDCQS38no/
         4LILfOF/7t7QJdyshvAhSqWgitYTFhNz2SuBCFvTzxVDjyhxEY/LOSulfvXSYIPRJ46F
         FWZefhKiXvyOCnqUNFMTHryXgQ/x0VsnU5ErA=
MIME-Version: 1.0
In-Reply-To: <201006052228.03025.linux@rainbow-software.org>
References: <201006042201.29872.linux@rainbow-software.org>
	<87vd9yjpj4.fsf@pollan.anholt.net>
	<201006052228.03025.linux@rainbow-software.org>
Date: Sun, 6 Jun 2010 19:04:44 +1000
Message-ID: <AANLkTinLPi93TvXcudNKPPWQaiD6xUrqvEESoxHnlIif@mail.gmail.com>
Subject: Re: regression: 2.6.35-rc1 hangs on i865G with KMS
From: Dave Airlie <airlied@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0003255768eeec64f5048858d85b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0003255768eeec64f5048858d85b
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jun 6, 2010 at 6:28 AM, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Saturday 05 June 2010 02:23:27 Eric Anholt wrote:
>> On Fri, 4 Jun 2010 22:01:28 +0200, Ondrej Zary <linux@rainbow-software.org> wrote:
>> > Hello,
>> > I'm testing 2.6.35-rc1 kernel on Asus P4P800-VM (i865G chipset). After
>> > loading i915 module, the screen goes blank and the kernel hangs
>> > completely (same with 2.6.35-rc1-git2). This does not happen with
>> > "i915.modeset=0" parameter.
>> >
>> > This problem does not appear with 2.6.34. Is this a known regression?
>>
>> Not known as far as I know -- we'd enjoy a bisect with a bug report on
>> bugs.freedesktop.org.

Can you try the attached patch?

Dave.

--0003255768eeec64f5048858d85b
Content-Type: application/octet-stream; 
	name="0001-drm-i915-fix-oops-on-single-crtc-devices.patch"
Content-Disposition: attachment; 
	filename="0001-drm-i915-fix-oops-on-single-crtc-devices.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ga3n8bv60

RnJvbSA4ZjkyNzYzMDQ3NjYyMDU1MjhhODVlMzEzNGE1MTI2ZmVhMzZlMGM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBTdW4sIDYgSnVuIDIwMTAgMTg6NTk6NDEgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vaTkx
NTogZml4IG9vcHMgb24gc2luZ2xlIGNydGMgZGV2aWNlcy4KCk15IGZiIHJld29yayBkaWRuJ3Qg
cmVtZW1iZXIgYWJvdXQgdGhlIDg0LzY1cy4KClJlcG9ydGVkLWJ5OiBPbmRyZWogWmFyeSA8bGlu
dXhAcmFpbmJvdy1zb2Z0d2FyZS5vcmc+ClNpZ25lZC1vZmYtYnk6IERhdmUgQWlybGllIDxhaXJs
aWVkQHJlZGhhdC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaCAgICAg
IHwgICAgMSArCiBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMgfCAgICA5ICsr
KystLS0tLQogZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZmIuYyAgICAgIHwgICAgMiArLQog
MyBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaCBiL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2k5MTVfZHJ2LmgKaW5kZXggN2Y3OTdlZi4uYWM3YTQ0MiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9ncHUvZHJtL2k5MTUvaTkxNV9kcnYuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1
X2Rydi5oCkBAIC0yODksNiArMjg5LDcgQEAgdHlwZWRlZiBzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0
ZSB7CiAJc3RydWN0IG1lbV9ibG9jayAqYWdwX2hlYXA7CiAJdW5zaWduZWQgaW50IHNyMDEsIGFk
cGEsIHBwY3IsIGR2b2IsIGR2b2MsIGx2ZHM7CiAJaW50IHZibGFua19waXBlOworCWludCBudW1f
cGlwZTsKIAogCS8qIEZvciBoYW5nY2hlY2sgdGltZXIgKi8KICNkZWZpbmUgRFJNX0k5MTVfSEFO
R0NIRUNLX1BFUklPRCA3NSAvKiBpbiBqaWZmaWVzICovCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9k
aXNwbGF5LmMKaW5kZXggOGM2NjhlMy4uMDg0YTQ4NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVs
X2Rpc3BsYXkuYwpAQCAtNTMxMCw3ICs1MzEwLDYgQEAgc3RhdGljIHZvaWQgaW50ZWxfaW5pdF9k
aXNwbGF5KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpCiB2b2lkIGludGVsX21vZGVzZXRfaW5pdChz
dHJ1Y3QgZHJtX2RldmljZSAqZGV2KQogewogCXN0cnVjdCBkcm1faTkxNV9wcml2YXRlICpkZXZf
cHJpdiA9IGRldi0+ZGV2X3ByaXZhdGU7Ci0JaW50IG51bV9waXBlOwogCWludCBpOwogCiAJZHJt
X21vZGVfY29uZmlnX2luaXQoZGV2KTsKQEAgLTUzNDAsMTMgKzUzMzksMTMgQEAgdm9pZCBpbnRl
bF9tb2Rlc2V0X2luaXQoc3RydWN0IGRybV9kZXZpY2UgKmRldikKIAkJZGV2LT5tb2RlX2NvbmZp
Zy5mYl9iYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KGRldi0+cGRldiwgMCk7CiAKIAlpZiAoSVNf
TU9CSUxFKGRldikgfHwgSVNfSTlYWChkZXYpKQotCQludW1fcGlwZSA9IDI7CisJCWRldl9wcml2
LT5udW1fcGlwZSA9IDI7CiAJZWxzZQotCQludW1fcGlwZSA9IDE7CisJCWRldl9wcml2LT5udW1f
cGlwZSA9IDE7CiAJRFJNX0RFQlVHX0tNUygiJWQgZGlzcGxheSBwaXBlJXMgYXZhaWxhYmxlLlxu
IiwKLQkJICBudW1fcGlwZSwgbnVtX3BpcGUgPiAxID8gInMiIDogIiIpOworCQkgICAgICBkZXZf
cHJpdi0+bnVtX3BpcGUsIGRldl9wcml2LT5udW1fcGlwZSA+IDEgPyAicyIgOiAiIik7CiAKLQlm
b3IgKGkgPSAwOyBpIDwgbnVtX3BpcGU7IGkrKykgeworCWZvciAoaSA9IDA7IGkgPCBkZXZfcHJp
di0+bnVtX3BpcGU7IGkrKykgewogCQlpbnRlbF9jcnRjX2luaXQoZGV2LCBpKTsKIAl9CiAKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2ZiLmMgYi9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9pbnRlbF9mYi5jCmluZGV4IDZmNTNjZjcuLjA1M2Q2ZjkgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2ZiLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUv
aW50ZWxfZmIuYwpAQCAtMjQ5LDcgKzI0OSw3IEBAIGludCBpbnRlbF9mYmRldl9pbml0KHN0cnVj
dCBkcm1fZGV2aWNlICpkZXYpCiAJZGV2X3ByaXYtPmZiZGV2ID0gaWZiZGV2OwogCWlmYmRldi0+
aGVscGVyLmZ1bmNzID0gJmludGVsX2ZiX2hlbHBlcl9mdW5jczsKIAotCWRybV9mYl9oZWxwZXJf
aW5pdChkZXYsICZpZmJkZXYtPmhlbHBlciwgMiwKKwlkcm1fZmJfaGVscGVyX2luaXQoZGV2LCAm
aWZiZGV2LT5oZWxwZXIsIGRldl9wcml2LT5udW1fcGlwZSwKIAkJCSAgIElOVEVMRkJfQ09OTl9M
SU1JVCk7CiAKIAlkcm1fZmJfaGVscGVyX3NpbmdsZV9hZGRfYWxsX2Nvbm5lY3RvcnMoJmlmYmRl
di0+aGVscGVyKTsKLS0gCjEuNi42LjEKCg==
--0003255768eeec64f5048858d85b--
