Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2EEN2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 09:28:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2EEN1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 09:27:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Sat, 5 May 2012 07:22:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <201205041957.14205.arnd@arndb.de> <201205042316.55593.rjw@sisk.pl>
In-Reply-To: <201205042316.55593.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205050722.45500.arnd@arndb.de>
X-Provags-ID: V02:K0:ujnVfyVjo4RZxYThF1OQA7vLL/1T/zPyKjtnYN8652Y
 4d2rkrLO8cNtk3n3oQtVTxJ0+fgs1jl2ikshMW0r/5eiB1V+3s
 zWqxa8B6ToVoumwjky3TmQwE0BZyrERxER2SnMighWsRQZ52Ee
 ARfKqoahuLJcedLWS2+lnGytGAnHXFH79ViMmeHK4RITwe5mnt
 tPigj1nT8Fl73i8Punhu8wabldr6oepmWFazjL60TLEK6ZtJR+
 zPnRdQlw4SUcAz+ZP+EUHkGP4qX9jKK+VQPba9esJxbkMv5cZz
 XQhqJ6/CVHwBdCYukSoXzoMGUFsbolmviemZsbbr9XYh8kVfTK
 nq60tlVhsiSKJtVGA7vI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Rafael J. Wysocki wrote:
> I'm not sure if I understand your point correctly, so please let me clarify.
> 
> Do you think it's better to have a separate mach-emma directory for the
> new hardware because technically it is a different platform and the fact
> that it was developed by the same manufacturer as the mach-shmobile hardware
> is less important?

Yes, that was my point. Compare this to how we have omap and davinci for TI,
orion and pxa for Marvell, or mxs and imx for Freescale. These are all
for the most part independent developments that happened to end up being
owned by the same company.

We try to group code based on technical similarities, not on who makes them.
If you are able to share code between multiple completely independent socs
you work on, the result shouldn't be to put them into a directory you "own",
but to generalize the common parts so they can be shared with everyone else,
too.

	Arnd
