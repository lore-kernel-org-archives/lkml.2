Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2HAN4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:56:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52016 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912Ab2HAN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:56:15 -0400
Date: Wed, 1 Aug 2012 14:56:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/3] regmap: fix some error messages to take account of
 irq_reg_stride
Message-ID: <20120801135613.GX11892@opensource.wolfsonmicro.com>
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:01:54PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> A number of places in the code were printing error messages that included
> the address of a register, but were not calculating the register address
> in the same way as the access to the register. Use a temporary to solve
> this.

Applied, thanks.
