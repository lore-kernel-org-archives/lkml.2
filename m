Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2HATdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:33:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59205 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352Ab2HATdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:33:37 -0400
Date: Wed, 1 Aug 2012 20:33:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/3] regmap: store irq_chip inside regmap_irq_chip_data
Message-ID: <20120801193334.GC4483@opensource.wolfsonmicro.com>
References: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:40:47AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> This will allow later patches to adjust portions of the irq_chip
> individually for each regmap_irq_chip that is created.

Applied all, thanks.
