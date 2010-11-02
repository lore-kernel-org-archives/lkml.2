Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0KCC76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 22:59:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:38597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab0KCC75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:59:57 -0400
Date: Tue, 2 Nov 2010 13:02:28 -0700
From: Greg KH <gregkh@suse.de>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Ball <cjb@laptop.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 29 (staging/ath6kl)
Message-ID: <20101102200228.GA2631@suse.de>
References: <20101029121148.d27e03bc.sfr@canb.auug.org.au> <20101029161610.99e6f4ef.randy.dunlap@oracle.com> <20101029235125.GA22122@suse.de> <35B17FE5076C7040809188FBE7913F983F847B52A2@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F847B52A2@SC1EXMB-MBCL.global.atheros.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 11:37:23AM -0700, Vipin Mehta wrote:
> 
> On Fri, Oct 29, 2010 at 04:16:10PM -0700, Randy Dunlap wrote:
> > On Fri, 29 Oct 2010 12:11:48 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > 
> > 
> > drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error: 'struct mmc_host' has no member named 'max_hw_segs'
> > drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error: 'struct mmc_host' has no member named 'max_hw_segs'
> 
> Looks like it was caused by:
> 	a36274e0184193e393fb82957925c3981a6b0477
> 
> 	mmc: Remove distinction between hw and phys segments
> 
> 
> and it's a simple fix.  I'll do it after -rc1 is out as I'm on my way to
> Boston now...
> 
> I had submitted a patch for this a few weeks back and the required
> changes were present in the tag next-20101028. They somehow got
> reverted back in the tag next-20101029. Both Greg and Stephen
> should have the original patch but I can send it again if it helps.
> 
> (Sorry my mutt is acting up so sending it through Outlook)

Yes, sorry, I have this in my queue, I too am busy in Boston :)

thanks,

greg k-h
