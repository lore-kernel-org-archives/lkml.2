Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1HRQG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:06:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52570 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755332Ab1HRQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:06:25 -0400
Date: Fri, 19 Aug 2011 01:06:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ian <ian@opensource.wolfsonmicro.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        u.kleine-koenig@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added #include of module.h to s3c_adc_battery.c
Message-ID: <20110818160612.GB20208@opensource.wolfsonmicro.com>
References: <1313662449.18176.18.camel@Tapajos>
 <201108181321.11293.anarsoul@gmail.com>
 <1313663688.18176.23.camel@Tapajos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313663688.18176.23.camel@Tapajos>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 11:34:48AM +0100, Ian wrote:
> On Thu, 2011-08-18 at 13:21 +0300, Vasily Khoruzhick wrote:
> > On Thursday 18 August 2011 13:14:09 Ian wrote:
> > > s3c_adc_battery.c will not compile without moule.h as it contains the
> > > definitions of: MODULE_AUTHOR, MODULE_DESCRIPTION & MODULE_LICENSE.
> > 
> > I've already sent pretty same patch a ~week ago, here it is:
> > https://patchwork.kernel.org/patch/1061302/
> 
> Ah, apologies - please disregard this patch then.

Hrm, Anton's been pretty quiet recently - might be an idea to start
CCing akpm on this stuff?
