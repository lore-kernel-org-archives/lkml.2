Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2HaA3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:29:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:37969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2HaA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:29:29 -0400
Message-ID: <1346373399.15463.2.camel@vkoul-mobl4>
Subject: Re: [PATCH] dma/ste_dma40: Fixup clock usage during probe
From: Vinod Koul <vkoul@infradead.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org, djbw@fb.com,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 31 Aug 2012 06:06:39 +0530
In-Reply-To: <1345722118-5783-1-git-send-email-ulf.hansson@stericsson.com>
References: <1345722118-5783-1-git-send-email-ulf.hansson@stericsson.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 13:41 +0200, Ulf Hansson wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Fixup some errorhandling for clocks during probe and make sure
> to use clk_prepare as well as clk_enable.
> 
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
Applied, thanks

-- 
~Vinod Koul
Intel Corp.

