Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2HINA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:00:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39731 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185Ab2HINA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:00:28 -0400
Date: Thu, 9 Aug 2012 14:00:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] regulator: add MAX8907 driver
Message-ID: <20120809130025.GQ24328@opensource.wolfsonmicro.com>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
 <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org>
 <5023AAE5.90603@nvidia.com>
 <20120809123838.GP24328@opensource.wolfsonmicro.com>
 <5023AC97.60409@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023AC97.60409@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:57:03PM +0530, Laxman Dewangan wrote:
> On Thursday 09 August 2012 06:08 PM, Mark Brown wrote:

> >The driver should just register all the regulators the chip has, it's
> >useful for diagnostic purposes if nothing else.

> Then probably we need to update our dts file becasue we left some of
> regualtor entry as it is not used on design.

Why would this impact the device tree?
