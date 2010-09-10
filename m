Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0IJQjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:39:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:34664 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab0IJQja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,347,1280732400"; 
   d="scan'208";a="836610199"
Date: Fri, 10 Sep 2010 18:39:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonyoung Shim <dofmind@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        a.zummo@towertech.it, p_gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v3 0/3] MAX8998 changes for RTC
Message-ID: <20100910163948.GN2561@sortiz-mobl>
References: <4C5B732D.8000301@samsung.com>
 <AANLkTi=PxMNRunKSi9hSf95jUA1PFKYka9ASaNQgFmGV@mail.gmail.com>
 <20100825122123.667ec04f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825122123.667ec04f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:21:23PM -0700, Andrew Morton wrote:
> On Wed, 25 Aug 2010 17:55:00 +0900
> Joonyoung Shim <dofmind@gmail.com> wrote:
> 
> > 2010/8/6 Joonyoung Shim <jy0922.shim@samsung.com>:
> > > Hi.
> > >
> > > This patchset is to support the RTC provided by the Maxim 8998 chip. For
> > > this first, needs i2c interface changes and interrupts support of
> > > max8998 mfd driver.
> > >
> > > Changes since v1:
> > >  - Fix missing braces of 3/3 patch from v1 review.
> > >  - The rest is same with v1.
> > >
> > > Changes since v2:
> > >  - add missing free_irq and rtc_valid_tm on rtc driver of 3/3 patch
> > >  - The rest is same with v2.
> > >
> > > Joonyoung Shim (3):
> > >      mfd: MAX8998: Use struct i2c_client to argument on i2c operation functions
> > >      mfd: MAX8998: Add interrupts support
> > >      rtc: Add MAX8998 rtc driver
> > >
> > 
> > Ping. Is there any feedback?
> 
> They look good to me.  Things are pretty delayed at present as I (and
> presumably others) recover from the -rc merge window..
> 
> I merged them.  Sam's acks on the MFD bits made life easier.
For some reasons I thought Liam was pushing this patchset through the last
merge window.
But now that the max8998 driver is upstreamed, I can carry those patches.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
