Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1H2MRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:17:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57338 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1H2MRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
References: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
Date: Mon, 29 Aug 2011 14:17:35 +0200
Message-ID: <CACRpkdYD3Av1oM=nZCt-USNcRhm2u2tF7biMw2vFaS7VygSqaA@mail.gmail.com>
Subject: Re: [PATCH 0/4] dmaeninge/ste_dma40: bug fixes for 3.1
From: Linus Walleij <linus.walleij@linaro.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:33 PM, Per Forlin <per.forlin@linaro.org> wrote:

> Started off fixing a memory leak due to not freed dma descriptors
> in mmci. The descriptor allocated at device_prep...(), not submitted,
> isn't freed at dmaeninge_terminate_all() or dmaengine_release().
> While sorting this one out some other issues were found as well.
> * kernel doc missing
> * duplication of d40_pool_lli_free()
> * free of client descriptor triggers an oops.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For all patches, thanks Per!
Linus Walleij
