Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876Ab2EITlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:41:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:33485 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab2EITlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:41:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164104237"
Date: Wed, 9 May 2012 21:50:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] twl-regulator: define all feature flags in one place.
Message-ID: <20120509195041.GR1794@sortiz-mobl>
References: <20120501204259.27026.40156.stgit@notabene.brown>
 <20120501204449.27026.29720.stgit@notabene.brown>
 <20120502090848.GF4075@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502090848.GF4075@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, May 02, 2012 at 10:08:49AM +0100, Mark Brown wrote:
> On Wed, May 02, 2012 at 06:44:50AM +1000, NeilBrown wrote:
> > twl-regulator has a collection of feature flags, some defined
> > in twl-core.c and  one defined in i2c/twl.h.
> > This is confusing for anyone adding a new feature flag.
> > 
> > So collect them together and place them in twl.h immediately
> > after the structure in which they are initially set.
> 
> Please remember to always CC maintainers on patches and always use
> subject lines appropriate for the subsystem.  Adding Samuel since this
> is not a regulator patch.
Could you please re-send this patch to me ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
