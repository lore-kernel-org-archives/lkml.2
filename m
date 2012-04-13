Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2DMMzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:55:21 -0400
Received: from relay.sigmatic.fi ([80.69.161.51]:55605 "EHLO relay.sigmatic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab2DMMzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:55:07 -0400
Date: Fri, 13 Apr 2012 15:54:05 +0300
From: Hannu Heikkinen <hannuxx@iki.fi>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc: tegra: cleanup probe/remove routines
Message-ID: <20120413125405.GA5952@beyadr.localdomain>
References: <1334238054-31600-1-git-send-email-hannuxx@iki.fi>
 <D958900912E20642BCBC71664EFECE3E6DD67586A0@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD67586A0@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/12 11:05 +0530, Venu Byravarasu wrote:
> > +	if (info->tegra_rtc_irq <= 0)
> > +		return -EBUSY;
> Interrupt support is needed only for wake up or timer support.
> Apart from them RTC can be used for reference time keeping.
> 
> So, is it not good to print a warn message as "wake up
> with alarm is not supported" and proceed further instead of 
> returning failure from the driver itself?

I propose that this patch would go in as is, as this is mainly for adjusting 
probe/remove routines for using devm_* funcs, and to leave that above issue
you mentioned to another patch, as it would be a change to current behavior.


br,
Hannu

