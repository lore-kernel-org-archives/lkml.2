Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2HAURN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:17:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42502 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878Ab2HAURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:17:12 -0400
Date: Wed, 1 Aug 2012 21:17:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] regmap: initialize all irqs to wake disabled
Message-ID: <20120801201709.GU4483@opensource.wolfsonmicro.com>
References: <1343851044-7872-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343851044-7872-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 01:57:24PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The kerneldoc for irq_set_irq_wake() says:
> 
>     Enable/disable power management wakeup mode, which is
>     disabled by default.

Applied, thanks.
