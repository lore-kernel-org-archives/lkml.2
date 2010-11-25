Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0KYQOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:14:00 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44934 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0KYQN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:13:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=YYyHsWd4c3itgO/8e/sJ+Tqqeyd4w456z6eFaWfo5bCE1Y9/rSCseNu+zFipEpSMlj
         2cOfvFfZXuFuJ+YK+P3TETI7nPpSHgdLBAwHNMv6QDqeztv+I0AcESJcOJcBrQOpi3C9
         O27stVRkPdNDgW3w/9bblT4DilTSos1SZaDkg=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTin4r6-No01A_KNr8aNuYpyWTvmuA3LTDRZ5Lag6@mail.gmail.com>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
	<AANLkTin4r6-No01A_KNr8aNuYpyWTvmuA3LTDRZ5Lag6@mail.gmail.com>
Date: Thu, 25 Nov 2010 17:13:58 +0100
Message-ID: <AANLkTimLOeZ=sWLP=nM_vSqR1jPDXtR1Dp2Eor+Xfosf@mail.gmail.com>
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:41 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> On Thu, Nov 25, 2010 at 10:11 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> Hi Rafael,
>>
[ ... ]
>> # grep "error:" build_linux-next_next20101124.dileks.2.log
>> /home/sd/src/linux-2.6/linux-2.6.37-rc3/debian/build/source_i386_none/drivers/platform/x86/fujitsu-laptop.c:692:
>> error: implicit declaration of function ‘acpi_bus_get_power’
[ ... ]
>
> Guess this is conflicting with your patch
> "12-13-ACPI-PM-Drop-acpi_bus_get_power.patch".
>
> - Sedat -
>
> P.S.: Note to myself, add the following snippet for testing purposes:
>
> [ debian/config/i386/none/config.686 ]
> ...
> ##
> ## file: drivers/platform/x86/Kconfig
> ##
> # CONFIG_FUJITSU_LAPTOP is not set
> - EOT -
>

Applied on top of linux-next (next-20101125) and running.

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
