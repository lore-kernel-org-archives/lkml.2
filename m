Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab0JLJmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:42:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45888 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab0JLJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:42:35 -0400
Date: Tue, 12 Oct 2010 10:42:08 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101012094208.GD12845@flint.arm.linux.org.uk>
References: <20101012103314.41b00cbe.sfr@canb.auug.org.au> <20101012080354.GC29673@pengutronix.de> <20101012082814.GC12845@flint.arm.linux.org.uk> <20101012092357.GE29673@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101012092357.GE29673@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 11:23:57AM +0200, Uwe Kleine-König wrote:
> Hi Russell,
> 
> On Tue, Oct 12, 2010 at 09:28:14AM +0100, Russell King wrote:
> > On Tue, Oct 12, 2010 at 10:03:54AM +0200, Uwe Kleine-König wrote:
> > > On Tue, Oct 12, 2010 at 10:33:14AM +1100, Stephen Rothwell wrote:
> > > > Hi Russell,
> > > > 
> > > > Today's linux-next merge of the arm tree got a conflict in
> > > > arch/arm/mach-imx/mach-cpuimx27.c between commit
> > > > 4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
> > > > selection") from the arm-current tree and commit
> > > > 77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
> > > > to add imx-i2c devices") from the arm tree.
> > A more concerning question is - these recent conflicts have been happening
> > as a result of merging people's GIT trees, which tend to be sent close
> > to the merge window.
> > 
> > If the first time their changes become visible to linux-next is when
> > they're merged into my tree, something is wrong...
> I tried to reconstruct that.  I guess I cannot see yet that Russell took
> 4793ca4028e4dcdbf2740db50995c9378ded3cf8 because I have no access to
> Russell's kernel.org repo and his ftp.arm.linux.org.uk repo currently
> barfs for me and Stephen didn't push out a tree newer than 20101011 yet.

What's up with it?  What URL are you using?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
