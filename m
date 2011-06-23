Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab1FWO11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:27:27 -0400
Received: from imr4.ericy.com ([198.24.6.8]:44349 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759548Ab1FWO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:27:26 -0400
Date: Thu, 23 Jun 2011 07:26:41 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: LM95245 driver
Message-ID: <20110623142641.GD28311@ericsson.com>
References: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com>
 <201106231114.52841.alexander.stein@systec-electronic.com>
 <20110623113316.6ab5a84e@endymion.delvare>
 <201106231250.38266.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201106231250.38266.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 06:50:37AM -0400, Alexander Stein wrote:
> On Thursday 23 June 2011 11:33:16 Jean Delvare wrote:
> > On Thu, 23 Jun 2011 11:14:52 +0200, Alexander Stein wrote:
> > > Well, I noticed that. But I went the way lm95241 does. I'm also unsure
> > > which interval to choose, if user specify a unsupported interval. Choose
> > > the next small or the next greater one? Maybe you can give me a hint
> > > here.
> > 
> > BTW, is the LM95245 so incompatible that support couldn't be added to
> > the lm95241 driver? If both devices are compatible to a reasonable
> > degree, a single driver would be preferred.
> 
> Well, the register mapping is completly different. Also some configuration 
> bits are merged and moved into other registers than in lm95241. I doubt there 
> is much more compatibility than i2c transfers and temperature format (despite 
> unsigned/unsigned).
> 
Same conclusion here. Odd but true.

Guenter
