Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0LaJVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 04:21:14 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39098 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0LaJVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 04:21:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=YE0O3uBowUYXp25k5JtsEXaRkdlLdafyCsKed7VbOzsx2gVpfFMclUE4gsfgqiE8dJ
         3GJnkwlMAJNmknpjUP8/ZrFSTGcedWZkUSAdxdYAEXn1A4FIO5RH9wK4bNORuLw5NjT4
         37bLFHE4EWpRjuJgiwiEyVxCsk1fFBa57GsgI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTinJgXYhzZz-V8krP-6vR2cC2drMjPEUnrD5r_dX@mail.gmail.com>
References: <20101231145827.7cfa13f9.sfr@canb.auug.org.au>
	<AANLkTinJgXYhzZz-V8krP-6vR2cC2drMjPEUnrD5r_dX@mail.gmail.com>
Date: Fri, 31 Dec 2010 10:21:12 +0100
Message-ID: <AANLkTikZa2K7e-yCP7x0u4DKUak7VYitYznfpaJEz0H_@mail.gmail.com>
Subject: Re: linux-next: Tree for December 31
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: multipart/mixed; boundary=0016364ef320c51b8a0498b15240
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364ef320c51b8a0498b15240
Content-Type: text/plain; charset=UTF-8

On Fri, Dec 31, 2010 at 8:51 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> I did:
> mkdir next
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> cd linux-next
> (make an kernel)
> after that:
> git fetch --tags
> git remote update
>
> today is 31, and my version on linux-next is still 30.
>
>
> uname -a
> Linux ubuntu 2.6.37-rc8-next-20101230+ #1 SMP Fri Dec 31 08:00:39 EET
> 2010 i686 GNU/Linux
>
> The problem: Nouveau is not loaded.
>
> Attached dmesg from next and 2.6.37-rc8.
>

[1] contains:
-next-20101231

I prefer to wipe the localversion-next file (see attached file).

You have to rebuild each time your extra-modules on kernel-upgrade.
Debian has dkms package which rebuilds all extra-modules automagically.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=localversion-next;h=c39c506d10f3aad45388947c0a052eacd5eea4f4;hb=bfa221f25c0ec816f725c3a145bda4ee65a277ff

--0016364ef320c51b8a0498b15240
Content-Type: text/x-diff; charset=US-ASCII; name="Remove-localversion-next.patch"
Content-Disposition: attachment; filename="Remove-localversion-next.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gicvfcsq1

RnJvbSBhYTY1MTQ2ODY1YzI4MmRiMmYxNmE0YTJkOGIzOTExNmJmNDRhN2ZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBNb24sIDE4IE9jdCAyMDEwIDIyOjQ4OjM4ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gUmVt
b3ZlIGxvY2FsdmVyc2lvbi1uZXh0CgotLS0KIGxvY2FsdmVyc2lvbi1uZXh0IHwgICAgMSAtCiAx
IGZpbGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKIGRlbGV0ZSBt
b2RlIDEwMDY0NCBsb2NhbHZlcnNpb24tbmV4dAoKZGlmZiAtLWdpdCBhL2xvY2FsdmVyc2lvbi1u
ZXh0IGIvbG9jYWx2ZXJzaW9uLW5leHQKZGVsZXRlZCBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IGQx
ZWIxMWMuLjAwMDAwMDAKLS0tIGEvbG9jYWx2ZXJzaW9uLW5leHQKKysrIC9kZXYvbnVsbApAQCAt
MSArMCwwIEBACi0tbmV4dC0yMDEwMTIzMQotLSAKMS43LjIuMwoK
--0016364ef320c51b8a0498b15240--
