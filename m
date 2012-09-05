Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab2IEXSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:18:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54931 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2IEXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:18:10 -0400
Date: Wed, 5 Sep 2012 16:18:21 -0700
From: Olof Johansson <olof@lixom.net>
To: Roland Stigge <stigge@antcom.de>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, aletes.xgr@gmail.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [GIT PULL] ARM: mach-pnx4008: Remove architecture
Message-ID: <20120905231821.GG32084@quad.lixom.net>
References: <1345724548-18130-1-git-send-email-stigge@antcom.de>
 <50378084.3080102@antcom.de>
 <201208260441.25905.arnd@arndb.de>
 <503A3402.7090508@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503A3402.7090508@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 04:34:42PM +0200, Roland Stigge wrote:
> On 26/08/12 06:41, Arnd Bergmann wrote:
> > On Friday 24 August 2012, Roland Stigge wrote:
> >> On 23/08/12 14:22, Roland Stigge wrote:
> >>> This patch removes the ARM architecture mach-pnx4008. No direct support or user
> >>> feedback since 2006. Acknowledgements from NXP/Philips and Linux arm-soc
> >>> maintainers.
> >>>
> >>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> >>
> >> The patch was a bit too big for the mailing list - sorry.
> >>
> >> Now re-proposing via pull request, below.
> > 
> > I think the removal of the frame buffer driver should go separately via the
> > framebuffer maintainer (Florian Schandinat), I can take the rest through the
> > arm-soc tree.
> 
> Fine - consider the new pull request for arch-pnx4008, below.
> 
> (Patch for video is separate, now.)
> 
> Thanks,
> 
> Roland
> 
> 
> The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:
> 
>   Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)
> 
> are available in the git repository at:
> 
>   git://git.antcom.de/linux-2.6.git pnx4008-removal

Thanks, pulled into next/cleanup. If we can get an Ack out of the FB maintainer
for the driver removal we can pick that up too, or it can go in through his
tree.


-Olof
