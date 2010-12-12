Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0LLLqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 06:46:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55812 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993Ab0LLLp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 06:45:57 -0500
Date: Sun, 12 Dec 2010 11:46:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] mfd: Convert jz4740-adc to new irq_ methods
Message-ID: <20101212114608.GB15189@opensource.wolfsonmicro.com>
References: <1292090258-7858-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4D03CE07.4050100@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D03CE07.4050100@metafoo.de>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 08:16:23PM +0100, Lars-Peter Clausen wrote:

> > -	irq -= adc->irq_base;
> > +	data->irqirq -= adc->irq_base;

> This should rather be:
> unsigned int irq = data->irq - adc->irq_base;

Would be one of the ones I can't build that I did this on :)
