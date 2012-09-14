Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab2INQI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:08:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35279 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab2INQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:08:57 -0400
Date: Fri, 14 Sep 2012 17:08:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, olof@lixom.net,
        grant.likely@secretlab.ca, lrg@ti.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/5] ASoC: tegra: remove support of legacy DMA driver
 based access
Message-ID: <20120914160852.GE4684@opensource.wolfsonmicro.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
 <1345126397-28864-6-git-send-email-ldewangan@nvidia.com>
 <504936D3.8030203@wwwdotorg.org>
 <505353EF.7040904@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505353EF.7040904@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:57:35AM -0600, Stephen Warren wrote:
> On 09/06/2012 05:50 PM, Stephen Warren wrote:

> > I'd like to take this patch through the Tegra tree, since it relies on
> > the previous Tegra patches to convert to dmaengine. Could I please get
> > an ack if that's OK? Thanks.

> I'm still looking for an ack.

As with all the others here I need to see this so it can get reviewed,
the previous review was that the patch didn't work.  In general
contentless pings like this aren't terribly helpful...
