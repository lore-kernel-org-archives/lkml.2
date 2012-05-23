Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2EWO1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:27:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:36735 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab2EWO1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:27:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170394332"
Date: Wed, 23 May 2012 16:26:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <guenter@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Sierra <asierra@xes-inc.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-watchdog@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd tree
Message-ID: <20120523142658.GD23600@sortiz-mobl>
References: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
 <20120518083234.GW3074@spo001.leaseweb.com>
 <6.2.5.6.2.20120518181141.028c8090@roeck-us.net>
 <20120522163559.GD3074@spo001.leaseweb.com>
 <6.2.5.6.2.20120522153050.0284ee38@roeck-us.net>
 <20120523054430.GH3074@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523054430.GH3074@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

On Wed, May 23, 2012 at 07:44:30AM +0200, Wim Van Sebroeck wrote:
> Hi Sam,
> 
> Since %04llx with a typecast to u64 is the way to go (Thanks Stephen and Randy)...
> 
> > How do we make sure that Randy's patch makes it upstream ? The iTCO 
> > patch is currently in Sam's tree.
> 
> Can you carry Randy's patch/fix (since it fixes the change introduced by the iTCO_wdt mfd patch)?
> If not then I will apply the patch later on once the iTCO_wdt mfd patch is mainstream.
> 
I'd appreciate if you could take it. I'm trying to avoid taking more patches
at this moment.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
