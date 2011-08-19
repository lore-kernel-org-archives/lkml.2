Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab1HSQz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:55:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1HSQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:55:23 -0400
Date: Fri, 19 Aug 2011 20:55:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ian <ian@opensource.wolfsonmicro.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added #include of module.h to s3c_adc_battery.c
Message-ID: <20110819165518.GK22761@oksana.dev.rtsoft.ru>
References: <1313662449.18176.18.camel@Tapajos>
 <201108181321.11293.anarsoul@gmail.com>
 <1313663688.18176.23.camel@Tapajos>
 <20110818160612.GB20208@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110818160612.GB20208@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 01:06:13AM +0900, Mark Brown wrote:
> On Thu, Aug 18, 2011 at 11:34:48AM +0100, Ian wrote:
> > On Thu, 2011-08-18 at 13:21 +0300, Vasily Khoruzhick wrote:
> > > On Thursday 18 August 2011 13:14:09 Ian wrote:
> > > > s3c_adc_battery.c will not compile without moule.h as it contains the
> > > > definitions of: MODULE_AUTHOR, MODULE_DESCRIPTION & MODULE_LICENSE.
> > > 
> > > I've already sent pretty same patch a ~week ago, here it is:
> > > https://patchwork.kernel.org/patch/1061302/
> > 
> > Ah, apologies - please disregard this patch then.
> 
> Hrm, Anton's been pretty quiet recently - might be an idea to start
> CCing akpm on this stuff?

Don't panic. :-) I'm still here, been on a vacation (and was trying to
not read emails :-), then was catching up with my other duties.

Ian, I added your Signed-off-by line to the Vasily's patch, for
the credits.

Thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
