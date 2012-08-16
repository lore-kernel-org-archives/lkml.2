Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2HPRyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:54:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53874 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2HPRyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:54:02 -0400
Message-ID: <502D33B6.7070103@wwwdotorg.org>
Date: Thu, 16 Aug 2012 11:53:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, grant.likely@secretlab.ca, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/5] ARM: tegra: config: enable dmaengine based APB DMA
 driver
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345126397-28864-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
> Enable config for dmaengine based Tegra APB DMA driver and
> disable the legacy APB DMA driver (SYSTEM_DMA).

Laxman, if I apply this series to next-20120816 (plus a few patches in
my local work branch plus the CPU hotplug patches from Joseph, although
I suspect none of that matters), then audio playback on Tegra20 is
broken; the pitch is far too high. Audio playback on Tegra30 works as
expected.
