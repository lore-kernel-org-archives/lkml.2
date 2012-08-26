Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab2HZElq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 00:41:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2HZElo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 00:41:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [GIT PULL] ARM: mach-pnx4008: Remove architecture
Date: Sun, 26 Aug 2012 04:41:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <1345724548-18130-1-git-send-email-stigge@antcom.de> <50378084.3080102@antcom.de>
In-Reply-To: <50378084.3080102@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208260441.25905.arnd@arndb.de>
X-Provags-ID: V02:K0:BlYVPJ8xVCNl1d/eISTr4OzLcHjhsMcGr3wfMcxIew+
 Tkwh9AzcE/EPZMPS2je3YV80tr3hHbyNRiTFWF6KcEaR0l4SLu
 +oH4BLIlIOUFN26rsmUX8IYLF5e8E4pxk3IuaySzOuEFKFXrWJ
 juX1sX4+mNBL29hRYeFazkM+4xwbv9Ln9Js+Gqbhwgy7KW2t9X
 UXCAWz8sEqAmtKgpS71SQ3/qywxRPs04DB2L31RhrchhI3IllM
 g+0NLZH1R2/W43+dCuAMBijFfZEzup+oGWeM9osmCLLiKYRzQo
 I5CBwRQFFpwGdWVQZ3cyJbMV5mn0dhJ6nwJL0Yi7SfeVbfxIfb
 Do2yuNtAL5BUDmQM7s0I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012, Roland Stigge wrote:
> On 23/08/12 14:22, Roland Stigge wrote:
> > This patch removes the ARM architecture mach-pnx4008. No direct support or user
> > feedback since 2006. Acknowledgements from NXP/Philips and Linux arm-soc
> > maintainers.
> > 
> > Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> The patch was a bit too big for the mailing list - sorry.
> 
> Now re-proposing via pull request, below.

I think the removal of the frame buffer driver should go separately via the
framebuffer maintainer (Florian Schandinat), I can take the rest through the
arm-soc tree.

	Arnd
