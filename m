Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2HAN4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:56:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692Ab2HAN4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:56:33 -0400
Date: Wed, 1 Aug 2012 14:56:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/3] regmap: implement irq chip suspend/resume operations
Message-ID: <20120801135631.GY11892@opensource.wolfsonmicro.com>
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
 <1343415716-27134-2-git-send-email-swarren@wwwdotorg.org>
 <20120729210410.GM4384@opensource.wolfsonmicro.com>
 <5016C006.80008@wwwdotorg.org>
 <20120730173822.GN4468@opensource.wolfsonmicro.com>
 <5018311B.8070202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5018311B.8070202@wwwdotorg.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 01:25:15PM -0600, Stephen Warren wrote:

> It looks like the answer here is to set irq_chip flags
> IRQCHIP_MASK_ON_SUSPEND and IRQCHIP_SKIP_SET_WAKE. Perhaps regmap-irq
> should do this automatically if (!regmap_irq_chip.wake_base)?

Sounds like a plan.
