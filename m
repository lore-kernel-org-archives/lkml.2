Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1KIRHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:07:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:16777 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1KIRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:07:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,484,1315206000"; 
   d="scan'208";a="34937828"
Subject: Re: Staging clear up
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111109165316.GB4016@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
	 <20111109121329.GC21630@sirena.org.uk>
	 <1320854413.32205.948.camel@vkoul-udesk3>
	 <20111109164211.GA4016@opensource.wolfsonmicro.com>
	 <1320857261.32205.1051.camel@vkoul-udesk3>
	 <20111109165316.GB4016@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 22:33:01 +0530
Message-ID: <1320858181.32205.1087.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 16:53 +0000, Mark Brown wrote:
> On Wed, Nov 09, 2011 at 10:17:41PM +0530, Vinod Koul wrote:
> > On Wed, 2011-11-09 at 16:42 +0000, Mark Brown wrote:
> 
> > > Someone will need to fix the build breakage from peering at the headers
> > > from staging.
> 
> > Not really. The current driver will not build unless you tweak the
> > Kconfig. It has clear depends rule, so build will not break.
> 
> Well, if that's the case we may as well delete the ASoC driver too since
> it'll not be possible to build it :)
Okay how about this, I give you nice beer when you meet me next time :D
I will ensure it builds for you for 3.3

Offtopic: I am ready with v2 of compressed API, testing stuff out. If
you/Dimitris have stuff to add, please drop me a note. I didn't see any
update after I published the tree

-- 
~Vinod

