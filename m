Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2JOA4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 20:56:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40394 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab2JOA4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 20:56:43 -0400
Date: Mon, 15 Oct 2012 09:56:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] regmap: add API to get irq_domain from regmap irq
Message-ID: <20121015005634.GA24935@opensource.wolfsonmicro.com>
References: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
 <1349889545-21517-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349889545-21517-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: Beware the one behind you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:49:04PM +0530, Laxman Dewangan wrote:
> Add API regmap_irq_get_irq_domain() for getting the
> irq domain from regmap irq. The irq domain created on
> result of regmap_add_irq_chip() from driver.

Sorry, when doing the merge down after the merge window I realised that
I already have a patch there adding a function regmap_irq_get_domain()
which has been sitting there for a while now, I think it was just fat
fingers that meant it didn't make v3.7.
