Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1HZOQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:16:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57878 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1HZOQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:16:12 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <205ae102ed038641e32cf38c48334f9e.squirrel@xenotime.net>
References: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
	<205ae102ed038641e32cf38c48334f9e.squirrel@xenotime.net>
Date: Fri, 26 Aug 2011 16:16:11 +0200
Message-ID: <CA+icZUX1zaw7xxka8yP4B0tFt7XgXe=8faw8vBnNWm+6teJVaA@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 26 (i7core_edac)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e650584afae71304ab692f55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e650584afae71304ab692f55
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2011 at 10:07 AM, Randy Dunlap <rdunlap@xenotime.net> wrote=
:
>
> On Thu, August 25, 2011 10:00 pm, Stephen Rothwell wrote:
>> Hi all,
>>
>> The powerpc allyesconfig build still fails today.
>>
>> Changes since 20110825:
>
>
> on i386:
>
> ERROR: "__udivdi3" [drivers/edac/i7core_edac.ko] undefined!
>
> in both get_sdram_scrub_rate()
> and set_sdram_scrub_rate()
>
> --
> ~Randy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>

Hi Randy,

can you test with the patch attached, please?

( UNTESTED, just followed patches like "[PATCH] p54: Use do_div for
64-bit division to fix 32-bit kernels" or "[PATCH v1] carl9170: Use
do_div for 64-bit division to fix 32-bit kernels" )

Regards,
- Sedat -

--0016e650584afae71304ab692f55
Content-Type: text/x-patch; charset=US-ASCII; name="i7core_edac.c.diff"
Content-Disposition: attachment; filename="i7core_edac.c.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grt8s0yp0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZWRhYy9pN2NvcmVfZWRhYy5jIGIvZHJpdmVycy9lZGFjL2k3
Y29yZV9lZGFjLmMKaW5kZXggN2NiNjhkZS4uNGQ0ZjNhNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9l
ZGFjL2k3Y29yZV9lZGFjLmMKKysrIGIvZHJpdmVycy9lZGFjL2k3Y29yZV9lZGFjLmMKQEAgLTM3
LDYgKzM3LDcgQEAKICNpbmNsdWRlIDxsaW51eC9zbXAuaD4KICNpbmNsdWRlIDxhc20vbWNlLmg+
CiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgorI2luY2x1ZGUgPGFzbS9kaXY2NC5oPgogCiAj
aW5jbHVkZSAiZWRhY19jb3JlLmgiCiAKQEAgLTIxMDIsNyArMjEwMyw4IEBAIHN0YXRpYyBpbnQg
c2V0X3NkcmFtX3NjcnViX3JhdGUoc3RydWN0IG1lbV9jdGxfaW5mbyAqbWNpLCB1MzIgbmV3X2J3
KQogCQkgKiBwcm9ncmFtIHRoZSBjb3JyZXNwb25kaW5nIHJlZ2lzdGVyIHZhbHVlLgogCQkgKi8K
IAkJc2NydWJfaW50ZXJ2YWwgPSAodW5zaWduZWQgbG9uZyBsb25nKWZyZXFfZGNsa19taHogKgot
CQkJY2FjaGVfbGluZV9zaXplICogMTAwMDAwMCAvIG5ld19idzsKKwkJCWNhY2hlX2xpbmVfc2l6
ZSAqIDEwMDAwMDApOworCQlkb19kaXYoc2NydWJfaW50ZXJ2YWwsIG5ld19idyk7CiAKIAkJaWYg
KCFzY3J1Yl9pbnRlcnZhbCB8fCBzY3J1Yl9pbnRlcnZhbCA+IFNDUlVCSU5URVJWQUxfTUFTSykK
IAkJCXJldHVybiAtRUlOVkFMOwpAQCAtMjE1Myw3ICsyMTU1LDggQEAgc3RhdGljIGludCBnZXRf
c2RyYW1fc2NydWJfcmF0ZShzdHJ1Y3QgbWVtX2N0bF9pbmZvICptY2kpCiAKIAkvKiBDYWxjdWxh
dGUgc2NydWIgcmF0ZSB2YWx1ZSBpbnRvIGJ5dGUvc2VjIGJhbmR3aWR0aCAqLwogCXNjcnViX3Jh
dGUgPSAgKHVuc2lnbmVkIGxvbmcgbG9uZylmcmVxX2RjbGtfbWh6ICoKLQkJMTAwMDAwMCAqIGNh
Y2hlX2xpbmVfc2l6ZSAvIHNjcnVidmFsOworCQkxMDAwMDAwICogY2FjaGVfbGluZV9zaXplKTsK
Kwlkb19kaXYoc2NydWJfcmF0ZSwgc2NydWJ2YWwpOwogCXJldHVybiAoaW50KXNjcnViX3JhdGU7
CiB9CiAK
--0016e650584afae71304ab692f55--
