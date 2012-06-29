Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2F2QgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:36:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35151 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2F2QgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:36:13 -0400
Message-ID: <4FEDD97A.7050702@wwwdotorg.org>
Date: Fri, 29 Jun 2012 10:36:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: use dmaengine based dma driver
References: <1340969480-7702-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340969480-7702-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:31 AM, Laxman Dewangan wrote:
> Use the dmaengine based Tegra APB DMA driver for
> data transfer between SPI FIFO and memory in
> place of legacy Tegra APB DMA.
> 
> The new driver is selected if legacy driver is not
> selected and new DMA driver is enabled through config
> file.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

