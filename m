Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1GELZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:25:14 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53484 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1GELZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:25:09 -0400
Message-ID: <4E12F491.4070906@monstr.eu>
Date: Tue, 05 Jul 2011 13:25:05 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: rusty@rustcorp.com.au, arnd@ardnb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        cmetcalf@tilera.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] modules: make arch's use default loader hooks
References: <201106281245.19457.arnd@arndb.de> <1309461732-2875-1-git-send-email-jonas@southpole.se> <1309461732-2875-2-git-send-email-jonas@southpole.se>
In-Reply-To: <1309461732-2875-2-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn wrote:
> This patch removes all the module loader hook implementations in the
> architecture specific code where the functionality is the same as that
> now provided by the recently added default hooks.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  arch/alpha/kernel/module.c      |   34 ---------------------
>  arch/arm/kernel/module.c        |   29 +------------------
>  arch/avr32/kernel/module.c      |   20 -------------
>  arch/blackfin/kernel/module.c   |   21 -------------
>  arch/cris/kernel/module.c       |   43 ++-------------------------
>  arch/frv/kernel/module.c        |   57 ++----------------------------------
>  arch/h8300/kernel/module.c      |   45 ----------------------------
>  arch/ia64/kernel/module.c       |   16 ----------
>  arch/m32r/kernel/module.c       |   38 ------------------------
>  arch/m68k/kernel/module_mm.c    |   27 -----------------
>  arch/m68k/kernel/module_no.c    |   34 ---------------------
>  arch/microblaze/kernel/module.c |   35 ----------------------

I tested it on Microblaze.

Tested-by: Michal Simek <monstr@monstr.eu>

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
