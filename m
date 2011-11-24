Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1KXK5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:57:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59047 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab1KXK5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:57:03 -0500
Date: Thu, 24 Nov 2011 10:57:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] leds: Convert led platform drivers to
 module_platform_driver
Message-ID: <20111124105701.GF8470@opensource.wolfsonmicro.com>
References: <1322122004.10476.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322122004.10476.1.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 04:06:44PM +0800, Axel Lin wrote:
> Factor out some boilerplate code for platform driver registration
> into module_platform_driver.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
