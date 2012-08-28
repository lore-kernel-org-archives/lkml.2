Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2H1Si3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:38:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41880 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2H1Si1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:38:27 -0400
Date: Tue, 28 Aug 2012 20:38:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Warren <swarren@nvidia.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, vinod.koul@intel.com, djbw@fb.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: add const to of_device_id.data's structure
Message-ID: <20120828183815.GD28643@pengutronix.de>
References: <1345976063-24437-1-git-send-email-ldewangan@nvidia.com>
 <503AF6B6.1010808@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <503AF6B6.1010808@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 09:25:26PM -0700, Stephen Warren wrote:
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
> 
> I wonder if this should go through Uwe's branch that made similar
> changes for all other drivers though? Uwe now CC'd.
If you forward/bounce the patch to me I can include it in my branch. I
wonder if I missed this warning while testing. I did test all arm
defconfigs based on 3.6-rc1.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
