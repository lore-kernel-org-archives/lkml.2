Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2IFXuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:50:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56889 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2IFXuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:50:12 -0400
Message-ID: <504936AF.8010701@wwwdotorg.org>
Date: Thu, 06 Sep 2012 17:50:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com
CC: olof@lixom.net, lrg@ti.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 4/5] spi: tegra: remove support of legacy DMA driver based
 access
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-5-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345126397-28864-5-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
> Remove the support code which uses the legacy APB DMA driver
> for accessing the SPI FIFO.
> The driver will use the dmaengine based APB DMA driver for
> accessing reqding/writing to SPI FIFO.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Grant, Mark,

I'd like to take this patch through the Tegra tree, since it relies on
the previous Tegra patches to convert to dmaengine. Could I please get
an ack if that's OK? Thanks.
