Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0HYTW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:22:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab0HYTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:22:24 -0400
Date: Wed, 25 Aug 2010 12:21:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonyoung Shim <dofmind@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, a.zummo@towertech.it, p_gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH v3 0/3] MAX8998 changes for RTC
Message-Id: <20100825122123.667ec04f.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=PxMNRunKSi9hSf95jUA1PFKYka9ASaNQgFmGV@mail.gmail.com>
References: <4C5B732D.8000301@samsung.com>
	<AANLkTi=PxMNRunKSi9hSf95jUA1PFKYka9ASaNQgFmGV@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 17:55:00 +0900
Joonyoung Shim <dofmind@gmail.com> wrote:

> 2010/8/6 Joonyoung Shim <jy0922.shim@samsung.com>:
> > Hi.
> >
> > This patchset is to support the RTC provided by the Maxim 8998 chip. For
> > this first, needs i2c interface changes and interrupts support of
> > max8998 mfd driver.
> >
> > Changes since v1:
> >  - Fix missing braces of 3/3 patch from v1 review.
> >  - The rest is same with v1.
> >
> > Changes since v2:
> >  - add missing free_irq and rtc_valid_tm on rtc driver of 3/3 patch
> >  - The rest is same with v2.
> >
> > Joonyoung Shim (3):
> >      mfd: MAX8998: Use struct i2c_client to argument on i2c operation functions
> >      mfd: MAX8998: Add interrupts support
> >      rtc: Add MAX8998 rtc driver
> >
> 
> Ping. Is there any feedback?

They look good to me.  Things are pretty delayed at present as I (and
presumably others) recover from the -rc merge window..

I merged them.  Sam's acks on the MFD bits made life easier.
