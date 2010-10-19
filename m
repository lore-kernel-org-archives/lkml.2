Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab0JSNe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:34:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:3209 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab0JSNez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="565409513"
Date: Tue, 19 Oct 2010 15:34:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] mfd/tc6393xb: don't use devinit data from non-init
 function
Message-ID: <20101019133451.GS2736@sortiz-mobl>
References: <1267546953-19319-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20101019071951.GB23839@pengutronix.de>
 <20101019103130.GK2736@sortiz-mobl>
 <20101019130705.GF11713@pengutronix.de>
 <20101019132228.GQ2736@sortiz-mobl>
 <20101019133344.GG11713@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101019133344.GG11713@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:33:44PM +0200, Uwe Kleine-König wrote:
> On Tue, Oct 19, 2010 at 03:22:29PM +0200, Samuel Ortiz wrote:
> > On Tue, Oct 19, 2010 at 03:07:05PM +0200, Uwe Kleine-König wrote:
> > > On Tue, Oct 19, 2010 at 12:31:31PM +0200, Samuel Ortiz wrote:
> > > > Hi Uwe,
> > > > 
> > > > On Tue, Oct 19, 2010 at 09:19:51AM +0200, Uwe Kleine-König wrote:
> > > > > Hello,
> > > > > 
> > > > > On Tue, Mar 02, 2010 at 05:22:33PM +0100, Uwe Kleine-König wrote:
> > > > > > tc6393xb_mmc_resources (which was marked __devinitdata) is used in
> > > > > > tc6393xb_mmc_enable() and tc6393xb_mmc_resume() which both are functions
> > > > > > living in .text.  This is not save with CONFIG_HOTPLUG=n.
> > > > > > 
> > > > > > This was introduced in
> > > > > > 
> > > > > > 	64e8867 (mfd: tmio_mmc hardware abstraction for CNF area)
> > > > > > 
> > > > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > > > Cc: Ian Molton <ian@mnementh.co.uk>
> > > > > > Cc: Magnus Damm <damm@opensource.se>
> > > > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > > > ping
> > > > This one slipped through...
> > > > I just applied a similar patch from Marek Vasut, are you ok with that ?
> > > Hmm, cannot find it, neither in next nor in your tree.
> > I just pushed it now.
> > See http://www.spinics.net/lists/arm-kernel/msg101220.html if you still can't
> > get it.
> the change is identical, so OK.  
Thanks for checking.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
