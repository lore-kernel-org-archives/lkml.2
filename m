Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2H1WBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:01:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2H1WBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:01:04 -0400
Message-ID: <1346191693.27195.6.camel@vkoul-mobl4>
Subject: Re: [PATCH] dma: tegra: add const to of_device_id.data's structure
From: Vinod Koul <vkoul@infradead.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: vinod.koul@intel.com, Laxman Dewangan <ldewangan@nvidia.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        djbw@fb.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Date: Wed, 29 Aug 2012 03:38:13 +0530
In-Reply-To: <503AF6B6.1010808@nvidia.com>
References: <1345976063-24437-1-git-send-email-ldewangan@nvidia.com>
	 <503AF6B6.1010808@nvidia.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-26 at 21:25 -0700, Stephen Warren wrote:
> On 08/26/2012 03:14 AM, Laxman Dewangan wrote:
> > The membe "data" of structure of_device_id is changed to const
> > pointer. Hence initializing this with const type data.
> > This will fix the compilation warning like
> > drivers/dma/tegra20-apb-dma.c:1217:9: warning: assignment discards 'const' qualifier from
> > pointer target type [enabled by default]
> > 
> > This warning came after the change
> > ---------
> > commit 98d7bbb9929bcc14e11ac8a55245a4f2dc174e17
> > Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >     of: add const to struct *of_device_id.data
> > ---------
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod Koul
Intel Corp.

