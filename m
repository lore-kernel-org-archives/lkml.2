Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520Ab2FVRJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:09:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42230 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2FVRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:09:27 -0400
Message-ID: <4FE4A6C4.6000609@wwwdotorg.org>
Date: Fri, 22 Jun 2012 11:09:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: tegra: set DMA_CYCLIC capability
References: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 05:42 AM, Laxman Dewangan wrote:
> Tegra's APB DMA driver support the cyclic mode of data
> transfer and hence setting the DMA_CYCLIC caps for dma
> channels.
> 
> This is require when generic sound dmaengine pcm driver
> request for dma channel with CYCLIC capability.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
