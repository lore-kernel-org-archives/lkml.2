Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1KERvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 13:51:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1KERvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 13:51:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: OMAP3: Fix dependencies for OMAP3_EMU
Date: Sat, 5 Nov 2011 18:51:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Weber <weber@corscience.de>, tony@atomide.com,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1320512279-9032-1-git-send-email-weber@corscience.de> <20111105160020.GA15294@n2100.arm.linux.org.uk>
In-Reply-To: <20111105160020.GA15294@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111051851.04879.arnd@arndb.de>
X-Provags-ID: V02:K0:RucpMPu/thi1l/SqeEGCFVKkqzzlX4EuN0FX7nO1h9H
 4roeTk+WO0uFkkgYeTVOplsb3jrvketwNZXqa3LXUdy2aNAXUH
 mr6UrzJr9UqqqJ9P4Fq835ALdvaCs6wi/d0TdN8oU8me/NXO2L
 itGljL/d+t2Nd/PIbTVqqnqFC9UITyEIV2gEK5pllWua59I0iD
 5HkhreQ2SU174QOJgoieu8luHvfNnEbf7eIhcMmXRiY0DBrby7
 zt4DbiouaTFhUenCE4egVskJuP1JnGo4Lh2WRZsUHQSnl3A39b
 yrqpuVClg0ZSGrMErVjiyFPNGJyf3d8qW1M9/1iBJUxzFA7+IB
 ZkU9FfPfKcRdvAZfRWi4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 November 2011, Russell King - ARM Linux wrote:
> On Sat, Nov 05, 2011 at 05:57:59PM +0100, Thomas Weber wrote:
> > This patch fixes the dependencies for OMAP3_EMU after
> > commit 53eebb0df85e4005
> > ARM: OC_ETM should not select ARM_AMBA
> > 
> > When "OMAP3 debugging peripherals" is selected the warning:
> > (OMAP3_EMU) selects OC_ETM which
> > has unmet direct dependencies (ARM_AMBA)
> 
> There is a patch from Arnd addressing this which was sent in October.
> It was acked by Santosh and Tony.  What happened to it?

I haven't gotten around to put the omap patches I sent earlier into
a branch yet, with too much travelling over the last weeks.

Right now, I'm mostly worried about regression fixes for stuff that
broke in the merge window, but the patches are not lost yet and
I'll get to that next, possibly only after I return from my vacation
in a week.

	Arnd
