Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2JKHiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:38:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52422 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab2JKHiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:38:20 -0400
Date: Thu, 11 Oct 2012 16:38:12 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] regmap: add API to get irq_domain from regmap irq
Message-ID: <20121011073810.GD11726@opensource.wolfsonmicro.com>
References: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
 <1349889545-21517-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349889545-21517-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:49:04PM +0530, Laxman Dewangan wrote:
> Add API regmap_irq_get_irq_domain() for getting the
> irq domain from regmap irq. The irq domain created on
> result of regmap_add_irq_chip() from driver.

Applied, thanks.  I'll push out a signed tag 

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/irq

when I can (hopefully later today) for merging into other trees.
