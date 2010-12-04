Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0LDXCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 18:02:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45637 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0LDXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 18:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=A7yUcnZ4nZ8bwv7Yrj6nayxu/i39bTS2ItkUBqOyIFT/GTdHfxZr2o4PGHgfWDzl/2
         6lCJa3h9feimPGjMsO2zQcBTs+z+lSWgu+4NiKIdoMwn8lu9OSs+X6Pz2pI11FARrclU
         kdIeiUBgfJAvF0pSo7QkyEx5N/AQzKT69xG0s=
MIME-Version: 1.0
In-Reply-To: <AANLkTimx0U8-fAyDnnaFrUJfQMfEtcpYPymYbnBtEYK1@mail.gmail.com>
References: <C0A2BC8065D6AE4BA759B25FE7A3795E036E7186@WHQBEMAIL1.whq.wistron>
	<AANLkTimx0U8-fAyDnnaFrUJfQMfEtcpYPymYbnBtEYK1@mail.gmail.com>
Date: Sat, 4 Dec 2010 15:01:58 -0800
X-Google-Sender-Auth: FR-aYoU9Ycx_uDw6XWaJ0oebB_Y
Message-ID: <AANLkTimJqZ2bG9xH=4EifJ-qTGHJCUY7-ugj8Uo9Tw=1@mail.gmail.com>
Subject: Re: [PATCH] intel_mid_dma: Fix section mismatch warnings
From: Dan Williams <dan.j.williams@intel.com>
To: Major_Lee@wistron.com
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com
Content-Type: multipart/mixed; boundary=0016364d286b664a1004969da47e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d286b664a1004969da47e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 3, 2010 at 5:13 PM, Dan Williams <dan.j.williams@intel.com> wro=
te:
> On Tue, Nov 30, 2010 at 12:24 AM, =A0<Major_Lee@wistron.com> wrote:
>> Fix the following section mismatch warnings.
>
[...]
>> or name the variable:
>> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
>> *_console,

I went ahead and applied the attached.

Thanks,
Dan

--0016364d286b664a1004969da47e
Content-Type: application/octet-stream; 
	name="intel-mid-section-mismatch.patch"
Content-Disposition: attachment; filename="intel-mid-section-mismatch.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghb3wxt40

aW50ZWxfbWlkX2RtYTogZml4IHNlY3Rpb24gbWlzbWF0Y2ggd2FybmluZ3MKCkZyb206IERhbiBX
aWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgoKUmVuYW1lIGludGVsX21pZF9kbWFf
cGNpIHRvIGludGVsX21pZF9kbWFfcGNpX2RyaXZlciB0byBwaWNrIHVwIHRoZQphcHBsaWVkIGFu
bm90YXRpb25zIG9mIHRoYXQgc3VmZml4LgoKUmVwb3J0ZWQtYnk6IDxtYWpvcl9MZWVAd2lzdHJv
bi5jb20+ClNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwu
Y29tPgotLS0KIGRyaXZlcnMvZG1hL2ludGVsX21pZF9kbWEuYyB8ICAgIDYgKysrLS0tCiAxIGZp
bGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2RtYS9pbnRlbF9taWRfZG1hLmMgYi9kcml2ZXJzL2RtYS9pbnRlbF9taWRfZG1h
LmMKaW5kZXggNGM1NWQ0NS4uMzEwOWJkOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9kbWEvaW50ZWxf
bWlkX2RtYS5jCisrKyBiL2RyaXZlcnMvZG1hL2ludGVsX21pZF9kbWEuYwpAQCAtMTQxMSw3ICsx
NDExLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZfcG1fb3BzIGludGVsX21pZF9kbWFfcG0g
PSB7CiAJLnJ1bnRpbWVfaWRsZSA9IGRtYV9ydW50aW1lX2lkbGUsCiB9OwogCi1zdGF0aWMgc3Ry
dWN0IHBjaV9kcml2ZXIgaW50ZWxfbWlkX2RtYV9wY2kgPSB7CitzdGF0aWMgc3RydWN0IHBjaV9k
cml2ZXIgaW50ZWxfbWlkX2RtYV9wY2lfZHJpdmVyID0gewogCS5uYW1lCQk9CSJJbnRlbCBNSUQg
RE1BIiwKIAkuaWRfdGFibGUJPQlpbnRlbF9taWRfZG1hX2lkcywKIAkucHJvYmUJCT0JaW50ZWxf
bWlkX2RtYV9wcm9iZSwKQEAgLTE0MjksMTMgKzE0MjksMTMgQEAgc3RhdGljIGludCBfX2luaXQg
aW50ZWxfbWlkX2RtYV9pbml0KHZvaWQpCiB7CiAJcHJfZGVidWcoIklORk9fTURNQTogTE5XIERN
QSBEcml2ZXIgVmVyc2lvbiAlc1xuIiwKIAkJCUlOVEVMX01JRF9ETUFfRFJJVkVSX1ZFUlNJT04p
OwotCXJldHVybiBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZpbnRlbF9taWRfZG1hX3BjaSk7CisJcmV0
dXJuIHBjaV9yZWdpc3Rlcl9kcml2ZXIoJmludGVsX21pZF9kbWFfcGNpX2RyaXZlcik7CiB9CiBm
c19pbml0Y2FsbChpbnRlbF9taWRfZG1hX2luaXQpOwogCiBzdGF0aWMgdm9pZCBfX2V4aXQgaW50
ZWxfbWlkX2RtYV9leGl0KHZvaWQpCiB7Ci0JcGNpX3VucmVnaXN0ZXJfZHJpdmVyKCZpbnRlbF9t
aWRfZG1hX3BjaSk7CisJcGNpX3VucmVnaXN0ZXJfZHJpdmVyKCZpbnRlbF9taWRfZG1hX3BjaV9k
cml2ZXIpOwogfQogbW9kdWxlX2V4aXQoaW50ZWxfbWlkX2RtYV9leGl0KTsKIAo=
--0016364d286b664a1004969da47e--
