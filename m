Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2HIKJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:09:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49230 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab2HIKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:09:32 -0400
Date: Thu, 9 Aug 2012 11:09:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/3] regulator: add always set/clear masks to
 regulator_enable_regmap
Message-ID: <20120809100930.GH24328@opensource.wolfsonmicro.com>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:18:45PM -0600, Stephen Warren wrote:

> +				  rdev->desc->enable_mask |
> +				  rdev->desc->en_dis_set_mask |
> +				  rdev->desc->en_dis_clr_mask,
> +				  rdev->desc->enable_mask |
> +				  rdev->desc->en_dis_set_mask);

Two problems here.  One is that the names are *really* obscure and hard
to read, the other is that this breaks all existing users.
