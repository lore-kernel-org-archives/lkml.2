Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab2INPxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:53:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37718 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705Ab2INPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:53:41 -0400
Date: Fri, 14 Sep 2012 16:53:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, olof@lixom.net,
        grant.likely@secretlab.ca, lrg@ti.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/5] ASoC: tegra: remove support of legacy DMA driver
 based access
Message-ID: <20120914155335.GB4684@opensource.wolfsonmicro.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
 <1345126397-28864-6-git-send-email-ldewangan@nvidia.com>
 <50526DFE.5030709@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50526DFE.5030709@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:36:30PM -0600, Stephen Warren wrote:

> Please note that I've applied this to Tegra's for-3.7/dmaengine branch,
> even though it hasn't been ack'd by an ASoC maintainer.

Please don't apply this without review, we've got quite enough problems
with the dmaengine stuff as it is unfortunately so I want to keep a
handle on what's going on.  I didn't look at it since when it was
originally posted people found problems in testing so I was expecting a
respin of the series.
