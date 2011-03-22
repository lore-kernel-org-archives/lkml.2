Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1CVLFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:05:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:32736 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab1CVLFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,224,1299484800"; 
   d="scan'208";a="722824030"
Date: Tue, 22 Mar 2011 12:05:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Turischev <denis@compulab.co.il>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: manual merge of the spi tree with the mfd tree
Message-ID: <20110322110530.GC2351@sortiz-mobl>
References: <20110318154017.e45aa888.sfr@canb.auug.org.au>
 <20110318051627.GE18545@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318051627.GE18545@angua.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, Mar 17, 2011 at 11:16:27PM -0600, Grant Likely wrote:
> On Fri, Mar 18, 2011 at 03:40:17PM +1100, Stephen Rothwell wrote:
> > Hi Grant,
> > 
> > Today's linux-next merge of the spi tree got a conflict in
> > drivers/gpio/Kconfig between commit 390ff13830e5 ("gpio: Add Tunnel Creek
> > support to sch_gpio") from the mfd tree and commit 61ab3fe57e45 ("gpio;
> > Make Intel chipset gpio drivers depend on x86") from the spi tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.  I am assuming that the Tunnel Creek stuff should also depend
> > on X86?
> 
> It would appear so.  Thanks Stephen.
I fixed the merge issue in my tree now, since Grant's GPIO bits are in it
seems.


> BTW Samuel, looking at the commit message for 390ff13830e5:
> 
> commit 390ff13830e5bcc4f8585b396e3d15b1c04c0282
> Author: Denis Turischev <denis@compulab.co.il>
> Date:   Mon Mar 14 12:53:05 2011 +0200
> [...]
>     Signed-off-by: Denis Turischev <denis@compulab.co.il>
>     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> My Acked-by seems to be missing from the commit log.
This was a temporary commit pushed to my tree before getting your ACK. Commit
10022449a9d0ff4deeae1b8fddae3e35d62b7958 should have it now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
