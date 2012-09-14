Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2INQAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:00:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51611 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2INQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:00:43 -0400
Message-ID: <505354A7.3090502@wwwdotorg.org>
Date: Fri, 14 Sep 2012 10:00:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, olof@lixom.net,
        grant.likely@secretlab.ca, lrg@ti.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/5] ASoC: tegra: remove support of legacy DMA driver
 based access
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-6-git-send-email-ldewangan@nvidia.com> <50526DFE.5030709@wwwdotorg.org> <20120914155335.GB4684@opensource.wolfsonmicro.com>
In-Reply-To: <20120914155335.GB4684@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 09:53 AM, Mark Brown wrote:
> On Thu, Sep 13, 2012 at 05:36:30PM -0600, Stephen Warren wrote:
> 
>> Please note that I've applied this to Tegra's for-3.7/dmaengine branch,
>> even though it hasn't been ack'd by an ASoC maintainer.
> 
> Please don't apply this without review, we've got quite enough problems
> with the dmaengine stuff as it is unfortunately so I want to keep a
> handle on what's going on.  I didn't look at it since when it was
> originally posted people found problems in testing so I was expecting a
> respin of the series.

OK, I'll remove the series from next then.

But do note that I pinged 8 days ago for an ack, and received no
objections, and you were well aware that the bug was fixed since you
applied the fix to the Tegra ASoC PCM driver yourself, and we had
discussed this being a dependency for the dmaengine patches, and you'd
told me to just base the Tegra branch on top of your tree until a signed
tag was available for me to base upon.
