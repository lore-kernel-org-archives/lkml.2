Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab0JLJYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:24:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37754 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab0JLJYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:24:03 -0400
Date: Tue, 12 Oct 2010 11:23:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101012092357.GE29673@pengutronix.de>
References: <20101012103314.41b00cbe.sfr@canb.auug.org.au> <20101012080354.GC29673@pengutronix.de> <20101012082814.GC12845@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101012082814.GC12845@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, Oct 12, 2010 at 09:28:14AM +0100, Russell King wrote:
> On Tue, Oct 12, 2010 at 10:03:54AM +0200, Uwe Kleine-König wrote:
> > On Tue, Oct 12, 2010 at 10:33:14AM +1100, Stephen Rothwell wrote:
> > > Hi Russell,
> > > 
> > > Today's linux-next merge of the arm tree got a conflict in
> > > arch/arm/mach-imx/mach-cpuimx27.c between commit
> > > 4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
> > > selection") from the arm-current tree and commit
> > > 77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
> > > to add imx-i2c devices") from the arm tree.
> A more concerning question is - these recent conflicts have been happening
> as a result of merging people's GIT trees, which tend to be sent close
> to the merge window.
> 
> If the first time their changes become visible to linux-next is when
> they're merged into my tree, something is wrong...
I tried to reconstruct that.  I guess I cannot see yet that Russell took
4793ca4028e4dcdbf2740db50995c9378ded3cf8 because I have no access to
Russell's kernel.org repo and his ftp.arm.linux.org.uk repo currently
barfs for me and Stephen didn't push out a tree newer than 20101011 yet.

4793ca4028e4dc is a regression fix that should go into .36, so this is
OK, isn't it.  77a406da5a5b76445a816d5f043fc9aef4026ff1 is already some
time in Sascha's tree, and so in next.  But 4793ca4028e4dc is new and
only these two together conflict.

Stephen, note that Sascha fixed the same conflict already in his tree.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
