Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1DDJVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:21:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57999 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1DDJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=m0zP0tjDdNRzvHgy4k/gPvjVyc5oxmgoGJRlR9bV0bOr00f29CzyWu4w9AuXIOLYtw
         Z2uGWEh1h7vKxPNWbRg7rHWpWc6Rb2t8fN0QZlj7e5lsuEuxaln+tqY4EdrSWEZGqedr
         iZAGB1c6bJ5yVNYjwStIp5JU0PL5sESgNT2b8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 4 Apr 2011 11:21:43 +0200
Message-ID: <BANLkTikr62YPeDnkL3DKA1Nts5aRFxsO6Q@mail.gmail.com>
Subject: Re: linux-next: Tree for April 4 [BROKEN thinkpad_acpi]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 6:35 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20110401:
>
> Dropped tree: xen
>
> The net tree gained a build failure so I used the version from
> next-20110401.
>

Hi,

My build breaked today.
Looks like the issue was introduced by commit
2af915b1eda9a671973256540035f8a6da1d57b4:
"thinkpad_acpi: Convert printks to pr_<level>"

- Sedat -

P.S.: Attached excerpt from my build.log

[...]
  CC [M]  drivers/platform/x86/thinkpad_acpi.o
[...]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'hotkey_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:3233:2:
error: implicit declaration of function 'str_supported'
[-Werror=implicit-function-declaration]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:3233:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:3289:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'bluetooth_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:3991:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'wan_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:4179:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'uwb_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:4319:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'video_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:4419:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'light_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:4803:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:4803:2:
warning: format '%s' expects argument of type 'char *', but argument 3
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'cmos_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:4910:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'led_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:5281:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'beep_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:5404:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'thermal_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:5737:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'volume_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:6901:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
  CC [M]  net/sched/sch_sfb.o
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:
In function 'fan_init':
/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/source_i386_none/drivers/platform/x86/thinkpad_acpi.c:8001:2:
warning: format '%s' expects argument of type 'char *', but argument 2
has type 'int' [-Wformat]
  CC [M]  drivers/media/dvb/ttusb-dec/ttusbdecfe.o
cc1: some warnings being treated as errors

make[7]: *** [drivers/platform/x86/thinkpad_acpi.o] Error 1
make[6]: *** [drivers/platform/x86] Error 2
make[5]: *** [drivers/platform] Error 2

- Sedat -
