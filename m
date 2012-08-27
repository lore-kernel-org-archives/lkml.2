Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2H0Qmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:42:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58675 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2H0Qmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:42:38 -0400
Date: Mon, 27 Aug 2012 09:42:34 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Axel Lin <axel.lin@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] max8907: fix use of possibly NULL idata
Message-ID: <20120827164232.GH4339@opensource.wolfsonmicro.com>
References: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:19:18PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> If a regulator is not used by a board, it's quite legitimate not to
> provide platform data or a device tree node to configure it (i.e.
> regulator_init_data). In that case, during MAX8907 regulator's
> probe(), the idata variable will be NULL for that regulator. Prevent
> dereferincing it.

Applied, thanks.  Please do remember to use subject lines which match up
with the subsystem.
