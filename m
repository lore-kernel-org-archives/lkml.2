Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2EETZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:25:33 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2EETZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:25:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Sat, 5 May 2012 21:30:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <201205052108.03001.rjw@sisk.pl> <201205051921.13209.arnd@arndb.de>
In-Reply-To: <201205051921.13209.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205052130.21081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, Arnd Bergmann wrote:
> On Saturday 05 May 2012, Rafael J. Wysocki wrote:
> > Now, if you insist on us having a separate mach- directory for every platform
> > (SoC), we can do that I think, but then we should start with splitting up the
> > existing mach-shmobile into a number of SoC-specific directories rather than
> > adding new mach- directories for random new parts, because that goes against
> > our development history to date, which is important too IMHO.
> 
> All the chips in there so far share a common ancestry and they all use a
> significant subset of the same drivers shared with arch/sh: i2c-sh_mobile,
> sh-dma-engine, sh_cmt, sh-sci, sh_tmu, intc, pfc and sh_clk. AFAICT, this one
> uses none of those and apparently was developed by NEC before the merger with
> Renesas.

I see.  So your opinion is that it may have more in common with the other
ARM-based platforms?

Rafael
