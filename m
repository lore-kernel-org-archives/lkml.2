Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0LLSpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:45:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47904 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752657Ab0LLSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:45:11 -0500
Date: Sun, 12 Dec 2010 18:45:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert jz4740-adc to new irq_ methods
Message-ID: <20101212184522.GA20358@opensource.wolfsonmicro.com>
References: <1292154400-15759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1292172032-20463-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292172032-20463-1-git-send-email-lars@metafoo.de>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:40:32PM +0100, Lars-Peter Clausen wrote:
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Convert the jz4740-adc driver to use the recently introduced IRQ API
> variants which are passed struct irq_data rather than an IRQ number.

Hrm, what's that patch against?  I tried to replace my version with this
one but I'm unable to apply it against Samuel's tree, and git am can't
find what you're patching in any of the trees in my repository (which
includes -next).
