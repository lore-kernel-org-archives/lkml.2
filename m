Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1HMCvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 22:51:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53360 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752511Ab1HMCvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 22:51:47 -0400
Date: Sat, 13 Aug 2011 11:51:40 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [linux-next] ASoC: build failure with make eseries_pxa_defconfig
Message-ID: <20110813025139.GA32506@opensource.wolfsonmicro.com>
References: <1313201521.12790.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313201521.12790.2.camel@phoenix>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 10:12:01AM +0800, Axel Lin wrote:

> In the case of build with "make eseries_pxa_defconfig;make",
> both i2c and spi support are not configured.
> Thus CONFIG_REGMAP is default to disable.

Meh, right.  This is all due to Grant insisting on having direct
registration functions for each bus, previously we could just select
regmap.
