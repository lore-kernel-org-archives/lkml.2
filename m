Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab2JSQMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:12:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60110 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2JSQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:12:47 -0400
Message-ID: <50817BFC.9000106@wwwdotorg.org>
Date: Fri, 19 Oct 2012 10:12:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 4/4 v2] gpio/tegra: convert to use linear irqdomain
References: <1350644052-31926-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1350644052-31926-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 04:54 AM, Linus Walleij wrote:
> The Tegra driver tries to do the work of irq_domain_add_linear()
> by reserving a bunch of descriptors somewhere and keeping track
> of the base offset, then calling irq_domain_add_legacy(). Let's
> stop doing that and simply use the linear IRQ domain.
> 
> For this to work: use irq_create_mapping() in the IRQ iterator
> so that the descriptors get allocated here.

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
