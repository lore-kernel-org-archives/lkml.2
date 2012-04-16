Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2DPDV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:21:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18912 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2DPDV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:21:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 15 Apr 2012 20:21:56 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Hannu Heikkinen <hannuxx@iki.fi>
CC: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>
Date: Mon, 16 Apr 2012 08:51:51 +0530
Subject: RE: [PATCH] rtc: tegra: cleanup probe/remove routines
Thread-Topic: [PATCH] rtc: tegra: cleanup probe/remove routines
Thread-Index: Ac0ZdKwV6VwZJ3V8R6iOUBE6HQwCoACC1jNw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD6758822@BGMAIL02.nvidia.com>
References: <1334238054-31600-1-git-send-email-hannuxx@iki.fi>
 <D958900912E20642BCBC71664EFECE3E6DD67586A0@BGMAIL02.nvidia.com>
 <20120413125405.GA5952@beyadr.localdomain>
In-Reply-To: <20120413125405.GA5952@beyadr.localdomain>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be fine.

> -----Original Message-----
> From: Hannu Heikkinen [mailto:hannuxx@iki.fi]
> Sent: Friday, April 13, 2012 6:24 PM
> To: Venu Byravarasu
> Cc: rtc-linux@googlegroups.com; linux-kernel@vger.kernel.org;
> a.zummo@towertech.it
> Subject: Re: [PATCH] rtc: tegra: cleanup probe/remove routines
> 
> On 13/04/12 11:05 +0530, Venu Byravarasu wrote:
> > > +	if (info->tegra_rtc_irq <= 0)
> > > +		return -EBUSY;
> > Interrupt support is needed only for wake up or timer support.
> > Apart from them RTC can be used for reference time keeping.
> >
> > So, is it not good to print a warn message as "wake up
> > with alarm is not supported" and proceed further instead of
> > returning failure from the driver itself?
> 
> I propose that this patch would go in as is, as this is mainly for adjusting
> probe/remove routines for using devm_* funcs, and to leave that above issue
> you mentioned to another patch, as it would be a change to current behavior.
> 
> 
> br,
> Hannu

