Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0J2Xwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 19:52:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:46928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0J2Xw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 19:52:29 -0400
Date: Fri, 29 Oct 2010 16:51:25 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chris Ball <cjb@laptop.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 29 (staging/ath6kl)
Message-ID: <20101029235125.GA22122@suse.de>
References: <20101029121148.d27e03bc.sfr@canb.auug.org.au>
 <20101029161610.99e6f4ef.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029161610.99e6f4ef.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 04:16:10PM -0700, Randy Dunlap wrote:
> On Fri, 29 Oct 2010 12:11:48 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> 
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error: 'struct mmc_host' has no member named 'max_hw_segs'
> drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error: 'struct mmc_host' has no member named 'max_hw_segs'

Looks like it was caused by:
	a36274e0184193e393fb82957925c3981a6b0477

	mmc: Remove distinction between hw and phys segments


and it's a simple fix.  I'll do it after -rc1 is out as I'm on my way to
Boston now...

thanks,

greg k-h
