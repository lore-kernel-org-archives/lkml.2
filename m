Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2INQds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:33:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60995 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478Ab2INQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:33:46 -0400
Date: Fri, 14 Sep 2012 17:33:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, olof@lixom.net,
        grant.likely@secretlab.ca, lrg@ti.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/5] ASoC: tegra: remove support of legacy DMA driver
 based access
Message-ID: <20120914163340.GF4684@opensource.wolfsonmicro.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
 <1345126397-28864-6-git-send-email-ldewangan@nvidia.com>
 <50526DFE.5030709@wwwdotorg.org>
 <20120914155335.GB4684@opensource.wolfsonmicro.com>
 <505354A7.3090502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505354A7.3090502@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:00:39AM -0600, Stephen Warren wrote:

> But do note that I pinged 8 days ago for an ack, and received no
> objections, and you were well aware that the bug was fixed since you

I didn't read these mails enough to notice that they were asking for an
ack, they were followups to already discarded patches (the were
discarded due to the testing problems).  One of the things I do to deal
with mail overload is to drop followups to patches that I don't remember
reviewing (as in this case where the negative test reports arrived
before I saw the patches) or where I remember I was already happy.

> applied the fix to the Tegra ASoC PCM driver yourself, and we had
> discussed this being a dependency for the dmaengine patches, and you'd
> told me to just base the Tegra branch on top of your tree until a signed
> tag was available for me to base upon.

I knew it was a dependency, I didn't know that there were no further
changes required to the series - your note when you posted the patch
didn't mention anything.
