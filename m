Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2JIGk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:40:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab2JIGkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:40:22 -0400
Date: Tue, 9 Oct 2012 15:40:15 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: Convert tps6586x to irq_domain
Message-ID: <20121009064011.GQ8237@opensource.wolfsonmicro.com>
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
 <1349712805-10014-2-git-send-email-ldewangan@nvidia.com>
 <20121009060641.GE8237@opensource.wolfsonmicro.com>
 <5073BAA8.4060404@nvidia.com>
 <20121009062355.GJ8237@opensource.wolfsonmicro.com>
 <5073BE7F.5060107@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5073BE7F.5060107@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:34:47AM +0530, Laxman Dewangan wrote:

> The bit definitions are also different in status and mask register
> and yes, this will be again problem as we do in isr thread
>  data->status_buf[i] &= ~data->mask_buf[i];

> So given the constraint, generic will not work here.

OK, that's a good reason not to use the generic code.
