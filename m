Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1HJKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:41:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53277 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751884Ab1HJKla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:41:30 -0400
Date: Wed, 10 Aug 2011 19:41:20 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Robert Schwebel <rsc@pengutronix.de>
Subject: Re: [PATCH] mfd wm8350: rename static gpio_set_debounce()
Message-ID: <20110810104118.GA1529@opensource.wolfsonmicro.com>
References: <20110810080549.GX31404@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810080549.GX31404@pengutronix.de>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:05:49AM +0200, Sascha Hauer wrote:
> 
> The kernel already has a function with this name declared
> in asm-generic/gpio.h. So if this header leaks into wm8350/gpio.c
> we get

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
