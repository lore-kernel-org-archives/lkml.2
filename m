Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab0ENTJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:09:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50025 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0ENTJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:09:12 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18yW97qIDnT/QYBsUNbkcC2
Date: Fri, 14 May 2010 12:09:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       Jarkko Nikula <jhnikula@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-ID: <20100514190906.GA3428@atomide.com>
References: <20100507134334.75808884.sfr@canb.auug.org.au>
 <20100510202056.GG16460@atomide.com>
 <1273654744.2814.14.camel@tubuntu.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273654744.2814.14.camel@tubuntu.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@nokia.com> [100512 01:54]:
> Hi,
> 
> On Mon, 2010-05-10 at 22:20 +0200, ext Tony Lindgren wrote:
> > * Stephen Rothwell <sfr@canb.auug.org.au> [100506 22:05]:
> > > Hi Tomi,
> > > 
> > > Today's linux-next merge of the omap_dss2 tree got a conflict in
> > > arch/arm/mach-omap2/board-rx51-peripherals.c between commit
> > > e87da74e34ad151e6ae75ebb7a7bf447f02c0004 ("omap: rx51: Add supplies for
> > > the tlv320aic3x codec driver") from the omap tree and commit
> > > a693839eab0292aa234d7a6f48d40389389baebb ("OMAP: RX51: Add "vdds_sdi"
> > > supply voltage for SDI") from the omap_dss2 tree.
> > > 
> > > Just overlapping additions. I fixed it up (see below) and can carry the
> > > fix as necessary.
> > 
> > Thanks again Stephen. We will move the conflicting DSS board-*.c
> > file changes over to omap for next.
> > 
> > Tomi, do you want to do a branch of board-*.c patches for me to
> > pull, or do you want me to just pick this one?
> 
> I think it's ok to pick just this one. It's just adds a regulator
> supply, and doesn't interfere with anything. I just need to make sure
> linux-omap's for-next is merged first, before I send my pull request.

Thanks, I've picked this patch.
 
> I made a branch for it, based on linux-omap/for-next:
> git://gitorious.org/linux-omap-dss2/linux.git for-tony
> 
> And I dropped the patch from my for-next branch.

Tomi, next time please check that your branch is based on
either the most recent tag by Linus, or in the conflicting
cases you can base on omap-for-linus branch. Please don't
base on for-next or other branches that are not yet
static, we don't want the merge history of duplicate branches.

Regards,

Tony
