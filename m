Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0KCNfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:35:53 -0400
Received: from kroah.org ([198.145.64.141]:49122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab0KCNfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:35:52 -0400
Date: Wed, 3 Nov 2010 06:31:36 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Ball <cjb@laptop.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 29 (staging/ath6kl)
Message-ID: <20101103133136.GA18187@kroah.com>
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

It's now in my tree and will get to Linus soon.

thanks,

greg k-h
