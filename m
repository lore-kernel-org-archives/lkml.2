Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0HEFKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:10:54 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:14788 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0HEFKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:10:52 -0400
Date: Wed, 4 Aug 2010 23:10:51 -0600
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 09/15] Despecificate driver from iLO2
Message-ID: <20100805051051.GD11497@ldl.fc.hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
 <1280274663-9160-10-git-send-email-dannf@hp.com>
 <20100804201341.GC30740@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804201341.GC30740@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 10:13:41PM +0200, Wim Van Sebroeck wrote:
> Hi Dan,
> 
> > This driver supports both iLO2 and iLO3, but our user-visible strings
> > currently only reference iLO2. Let's just call it "iLO" to avoid having
> > to update strings for each iLO generation. This driver doesn't support
> > iLO ASICs prior to iLO2, but that is sufficiently explained in Kconfig.
> 
> Just a thought: Wouldn't it be more consistent if it's called iLO2+
> everywhere?

works for me :)

> 
> > -	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
> > +	tristate "HP Proliant iLO Hardware Watchdog Timer"
> 
> would be: tristate "HP Proliant iLO2+ Hardware Watchdog Timer"
> 
> > -	.identity = "HP iLO2 HW Watchdog Timer",
> > +	.identity = "HP iLO HW Watchdog Timer",
> 
> and: .identity = "HP iLO2+ HW Watchdog Timer",
> 
> > -	 * First let's find out if we are on an iLO2 server. We will
> > +	 * First let's find out if we are on an iLO2+ server. We will
> 
> > -		dev_warn(&dev->dev,
> > -			"This server does not have an iLO2 ASIC.\n");
> > +		dev_warn(&dev->dev, "This server does not have an iLO ASIC"
> > +			 " version 2 or greater.\n");
> 
> dev_warn(&dev->dev,
> 	"This server does not have an iLO2+ ASIC.\n");
> 
> > -			"Unable to detect the iLO2 server memory.\n");
> > +			"Unable to detect the iLO server memory.\n");
> 
> "Unable to detect the iLO2+ server memory.\n");
> 
> For the rest I'm still reviewing the code.

Thanks - I'll make this change in my local git tree for now and
resubmit after you've completed the review.

-- 
dann frazier | ProLiant Linux
