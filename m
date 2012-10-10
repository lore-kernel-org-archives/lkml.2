Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2JJCIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:08:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58337 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477Ab2JJCIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:08:34 -0400
Date: Wed, 10 Oct 2012 11:08:22 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] regmap: add API to get irq_domain from regmap irq
Message-ID: <20121010020819.GD17288@opensource.wolfsonmicro.com>
References: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
 <1349782116-9757-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349782116-9757-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:58:35PM +0530, Laxman Dewangan wrote:
> Add API regmap_irq_get_irq_domain() for getting the
> irq domain from regmap irq.
> The irq domain created on result of regmap_add_irq_chip()
> from driver.

This needs stubbing.  

Please also fix the formatting of your commit log, you're either
wrapping randomly in the middle of paragraphs or not leaving blank lines
between paragraphs.
