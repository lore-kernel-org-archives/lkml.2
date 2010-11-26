Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0KZOv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:51:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:12379 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0KZOvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:51:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,261,1288594800"; 
   d="scan'208";a="577882747"
Date: Fri, 26 Nov 2010 15:51:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/7] Wolfson MFD updates
Message-ID: <20101126145151.GA27663@sortiz-mobl>
References: <20101124180055.GO24970@rakim.wolfsonmicro.main>
 <20101126140518.GN5520@sortiz-mobl>
 <20101126140719.GH30360@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126140719.GH30360@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 26, 2010 at 02:07:19PM +0000, Mark Brown wrote:
> On Fri, Nov 26, 2010 at 03:05:19PM +0100, Samuel Ortiz wrote:
> > On Wed, Nov 24, 2010 at 06:00:55PM +0000, Mark Brown wrote:
> 
> > > This is a reposting of a number of Wolfson MFD patches previously posted
> > > - I seem to building up a relatively large queue of patches here.
> 
> > > Patch 1/7 is a bugfix and really ought to go into 2.6.37, patch 7/7
> > > would ideally be merged via ASoC as the bulk of the support for this
> > > device is in the CODEC driver, 2-3 are a new device and 4-6 are some
> > > housekeeping for new kernel APIs.
> 
> > All 7 patches applied, thanks a lot.
> 
> Thanks!
> 
> Would it be OK to apply patch 7 to the ASoC tree?  There's a bunch of
> CODEC driver changes to support the WM8958 which depend on it and also
> depend on changes in the ASoC tree.
Sure, I'm fine with that.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
