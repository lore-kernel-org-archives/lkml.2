Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0HOPVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:21:50 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34268 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282Ab0HOPVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type;
        b=A5FyUvWsWyXtYuroXB21gqkezd43B9Y+pexY7MbWGDa+WWKB9c6dKVVIpRdOlZOlM7
         LccbhU+ChmwiUsVoo2NU4fjqoz31Yg8W3QMoM56dT5HczgNjFe2p844QEoM5TJcncTF/
         zOpxQ3kAkSI+tB0X7FfV1RkESyEe23bCKpmhQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
Date: Sun, 15 Aug 2010 13:13:07 +0200
Message-ID: <AANLkTinzB=y4ntchu9fDeJ7XCkG9OJanvQUbMqtdWUrR@mail.gmail.com>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: len.brown@intel.com, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015175cd592ed909b048ddaccb6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175cd592ed909b048ddaccb6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 15, 2010 at 12:41 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> I pulled in release GIT-branch on top of 2.6.35-git16 (commit
> 5d7cb157025b3b4852f38e6e5e97d06ef12c1d78)
>
> =C2=A0 $ git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.=
6.git
> release
>
> Unfortunately, the build breaks:
>
> [ build.log ]
> drivers/acpi/power.c: In function =E2=80=98acpi_power_off_device=E2=80=99=
:
> drivers/acpi/power.c:252: error: =E2=80=98ref=E2=80=99 undeclared (first =
use in this function)
> drivers/acpi/power.c:252: error: (Each undeclared identifier is
> reported only once
> drivers/acpi/power.c:252: error: for each function it appears in.)
> make[5]: *** [drivers/acpi/power.o] Error 1
> make[4]: *** [drivers/acpi] Error 2
> make[3]: *** [drivers] Error 2
>

Attached patch is fixing the issue here.

- Sedat -

--0015175cd592ed909b048ddaccb6
Content-Type: text/x-diff; charset=US-ASCII; 
	name="ACPI-Fix-undeclared-ref-in-acpi_power_off_device.patch"
Content-Disposition: attachment; 
	filename="ACPI-Fix-undeclared-ref-in-acpi_power_off_device.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcvsqbm00

ZGlmZiAtcmR1cCBsaW51eC0yLjYub3JpZy9kcml2ZXJzL2FjcGkvcG93ZXIuYyBsaW51eC0yLjYv
ZHJpdmVycy9hY3BpL3Bvd2VyLmMKLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvYWNwaS9wb3dl
ci5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9hY3BpL3Bvd2VyLmMKQEAgLTI0Miw2ICsyNDIsNyBA
QCBzdGF0aWMgaW50IGFjcGlfcG93ZXJfb2ZmX2RldmljZShhY3BpX2hhCiAJYWNwaV9zdGF0dXMg
c3RhdHVzID0gQUVfT0s7CiAJc3RydWN0IGFjcGlfcG93ZXJfcmVzb3VyY2UgKnJlc291cmNlID0g
TlVMTDsKIAlzdHJ1Y3QgbGlzdF9oZWFkICpub2RlLCAqbmV4dDsKKwlzdHJ1Y3QgYWNwaV9wb3dl
cl9yZWZlcmVuY2UgKnJlZjsKIAogCXJlc3VsdCA9IGFjcGlfcG93ZXJfZ2V0X2NvbnRleHQoaGFu
ZGxlLCAmcmVzb3VyY2UpOwogCWlmIChyZXN1bHQpCg==
--0015175cd592ed909b048ddaccb6--
