Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1E2Uks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:40:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2313 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1E2Ukr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:40:47 -0400
Subject: Re: [PATCH 2/4] staging: Remove direct includes of printk.h
From: Joe Perches <joe@perches.com>
To: julie Sullivan <kernelmail.jms@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        Dowan Kim <dowan@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTimY9-ng8HVm+QFyS8FYks_mFx=ong@mail.gmail.com>
References: <cover.1306342673.git.joe@perches.com>
	 <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
	 <a605f8a8039f83fae3fbf61b58f846bc3c58c379.1306342673.git.joe@perches.com>
	 <BANLkTimY9-ng8HVm+QFyS8FYks_mFx=ong@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 May 2011 13:40:45 -0700
Message-ID: <1306701645.14524.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 18:00 +0100, julie Sullivan wrote: 
> > --- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
[] 
> types.h is also a subfile of kernel.h, right?

Yes it is.

> Or maybe you patched this one already - if so please excuse the noise :-)

No I didn't patch that one.

I think it wouldn't be good to do that.
printk.h may be a special case because it was
moved out of kernel.h just to make it a bit neater.

You are welcome to if you choose to.

There are like 1500 or so files that have both kernel.h and types.h

$ grep --include=*.[ch] -rP -l "^\s*\#\s*include\s+\<linux/types\.h>" * | \
  xargs grep -Pl "^\s*\#\s*include\s+\<linux/kernel\.h\>" | wc -l
1572


