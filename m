Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2JIGOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:14:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53463 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab2JIGOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:14:47 -0400
Date: Tue, 9 Oct 2012 15:14:38 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, sameo@linux.intel.com, vbyravarasu@nvidia.com,
        axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: TPS51632: Add tps51632 regulator driver
Message-ID: <20121009061436.GH8237@opensource.wolfsonmicro.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349536671-31714-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 08:47:46PM +0530, Laxman Dewangan wrote:

Actually...

> +	if (pdata->dvfs_step_20mV)
> +		control |= TPS51632_DVFS_STEP_20;

> +	tps->desc.uV_step = TPS51632_VOLATGE_STEP_10mV;

Shouldn't the dvfs_step_20mV setting affect the uV_step size?
