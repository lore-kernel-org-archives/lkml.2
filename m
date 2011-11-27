Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1K0LXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:23:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57197 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab1K0LXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:23:31 -0500
Date: Sun, 27 Nov 2011 11:23:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: convert drivers/video/backlight/* to use
 module_platform_driver()
Message-ID: <20111127112328.GC2896@opensource.wolfsonmicro.com>
References: <1322273963.10633.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322273963.10633.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:19:23AM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/video/backlight/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
