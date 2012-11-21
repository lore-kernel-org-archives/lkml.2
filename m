Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2KUPHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:07:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41058 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab2KUPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:06:59 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4 v2] gpio/tegra: convert to use linear irqdomain
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1350644052-31926-1-git-send-email-linus.walleij@linaro.org>
References: <1350644052-31926-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 21 Nov 2012 15:06:55 +0000
Message-Id: <20121121150655.CA7033E0A47@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 12:54:12 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> The Tegra driver tries to do the work of irq_domain_add_linear()
> by reserving a bunch of descriptors somewhere and keeping track
> of the base offset, then calling irq_domain_add_legacy(). Let's
> stop doing that and simply use the linear IRQ domain.
> 
> For this to work: use irq_create_mapping() in the IRQ iterator
> so that the descriptors get allocated here.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

