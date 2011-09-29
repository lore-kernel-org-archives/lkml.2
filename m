Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1I2UQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:16:32 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46438 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab1I2UQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:16:30 -0400
Date: Thu, 29 Sep 2011 12:19:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/2] ARM: gic: add OF based initialization
Message-ID: <20110929171944.GD6800@ponder.secretlab.ca>
References: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
 <1317268436-1613-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317268436-1613-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:53:56PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This adds ARM gic interrupt controller initialization using device tree
> data.
> 
> The initialization function is intended to be called by of_irq_init
> function like this:
> 
> const static struct of_device_id irq_match[] = {
> 	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
> 	{}
> };
> 
> static void __init init_irqs(void)
> {
> 	of_irq_init(irq_match);
> }
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Looks good.

g.

