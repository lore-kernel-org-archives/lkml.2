Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2GBQC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:02:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59684 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2GBQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:02:54 -0400
Message-ID: <4FF1C62B.5070005@wwwdotorg.org>
Date: Mon, 02 Jul 2012 10:02:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: tegra: fix residual calculation for cyclic case
References: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 02:22 AM, Laxman Dewangan wrote:
> In cyclic mode of DMA, the byte transferred can be more
> than the requested size and in this case, calculating
> residuals based on the current position of DMA transfer to
> bytes requested i.e. bytes required to transfer to reach
> bytes requested from current DMA position.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

This makes sense to me, although I wonder if details like this aren't
something that the dmaengine core should be handling.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
