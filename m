Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762570Ab2FVRMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:12:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33072 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2FVRMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:12:50 -0400
Message-ID: <4FE4A78F.4090307@wwwdotorg.org>
Date: Fri, 22 Jun 2012 11:12:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: use sg_dma_address() for getting dma buffer
 address
References: <1340377870-10035-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340377870-10035-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 09:11 AM, Laxman Dewangan wrote:
> Use the sg_dma_address() to get the segment buffer address for
> DMA transfer in place of sg_phys() which returns the physical
> address of an sg entry.
> The sg_dma_address() returns the correct buffer memory address
> for DMA transfer.

It's what everyone else is doing, so:
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
