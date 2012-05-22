Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2EVVmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:42:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:53644 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2EVVmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:42:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169964120"
Date: Tue, 22 May 2012 23:52:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add r_select to lm3533 platform data
Message-ID: <20120522215210.GE10210@sortiz-mobl>
References: <1337365366-14385-1-git-send-email-jhovold@gmail.com>
 <20120520131337.GU12015@sortiz-mobl>
 <20120521084539.GB21033@localhost>
 <20120521090844.GA12015@sortiz-mobl>
 <20120521094138.GA20694@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521094138.GA20694@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Mon, May 21, 2012 at 11:41:38AM +0200, Johan Hovold wrote:
> On Mon, May 21, 2012 at 11:08:44AM +0200, Samuel Ortiz wrote:
> > Hi Johan,
> > 
> > On Mon, May 21, 2012 at 10:45:39AM +0200, Johan Hovold wrote:
> > > On Sun, May 20, 2012 at 03:13:37PM +0200, Samuel Ortiz wrote:
> > > > Hi Johan,
> > > > 
> > > > On Fri, May 18, 2012 at 08:22:45PM +0200, Johan Hovold wrote:
> > > > > Add resistor-select parameter to the platform data.
> > > > > 
> > > > > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > > > > ---
> > > > > 
> > > > > Hi Samuel, 
> > > > > 
> > > > > I believe this one needs to go in through mfd as the iio driver
> > > > > destined for staging-next depends on it.
> > > > It should go along with the iio driver if there is a build dependency.
> > > > No doing so will prevent the tree from being bisectable.
> > > 
> > > The sub-drivers already depend on mfd to build as this is where the
> > > header file resides. 
> > I haven't looked at it, but if the iio driver Kconfig entry depends on
> > MFD_LM3533, then I can take this change in as no one will be able to build
> > your iio driver until the MFD driver is merged.
> > Is that the case ?
> 
> Yes, it is.
Applied then.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
