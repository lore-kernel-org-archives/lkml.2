Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab0KQGaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:30:04 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44636 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab0KQGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:30:00 -0500
Message-ID: <4CE37663.2080806@bonesio.net>
Date: Tue, 16 Nov 2010 22:29:55 -0800
From: John Bonesio <bones@bonesio.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: John Bonesio <bones@secretlab.ca>, devicetree-discuss@lists.ozlabs.org,
        jdl@jdl.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, david@gibson.dropbear.id.au
Subject: Re: [PATCH 1/5] scripts: dtc: Merge in changes from the dtc repository
References: <20101116204917.12146.39851.stgit@riker>	<20101116204951.12146.21084.stgit@riker> <AANLkTinYZYR_QtS5-Nodpaf2MBBuaw06SW9pDCNQ9ov3@mail.gmail.com>
In-Reply-To: <AANLkTinYZYR_QtS5-Nodpaf2MBBuaw06SW9pDCNQ9ov3@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arg!

I had this working. I'll look into it.

- John

On 11/16/2010 10:11 PM, Grant Likely wrote:
> On Tue, Nov 16, 2010 at 1:49 PM, John Bonesio <bones@secretlab.ca> wrote:
>> Pull in recent changes from the main dtc repository. These changes primarily
>> allow multiple device trees to be declared which are merged by dtc. This
>> feature allows us to include a basic dts file and then provide more information
>> for the specific system through the merging functionality.
>>
>> Signed-off-by: John Bonesio <bones@secretlab.ca>
>> ---
>>
>>  0 files changed, 0 insertions(+), 0 deletions(-)
> ???  Something isn't right in patch generation.
>
> Also:
>
> ~/hacking/linux-2.6$ xc-6xx make -j3
>   GEN     /home/grant/hacking/linux-2.6.build/6xx/Makefile
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf --silentoldconfig Kconfig
> #
> # configuration written to .config
> #
>   GEN     /home/grant/hacking/linux-2.6.build/6xx/Makefile
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   HOSTCC  scripts/dtc/checks.o
> In file included from /home/grant/hacking/linux-2.6/scripts/dtc/checks.c:21:
> /home/grant/hacking/linux-2.6/scripts/dtc/dtc.h:37: fatal error:
> util.h: No such file or directory
> compilation terminated.
> make[3]: *** [scripts/dtc/checks.o] Error 1
> make[2]: *** [scripts/dtc] Error 2
> make[1]: *** [scripts] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [sub-make] Error 2
> (devicetree/test) ~/hacking/linux-2.6$
>
> Looks like the updated dtc is broken.
>
> g.
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

