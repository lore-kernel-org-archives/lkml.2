Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422992Ab2JaOuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:50:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17464 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965820Ab2JaOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 31 Oct 2012 07:49:56 -0700
Message-ID: <50913A30.60802@nvidia.com>
Date: Wed, 31 Oct 2012 20:18:16 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dma: tegra20-apbdma: channel freeing correction
References: <1351433873-14082-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1351433873-14082-1-git-send-email-digetx@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 October 2012 07:47 PM, Dmitry Osipenko wrote:
> Fixed channel "lock" after free.
>
> Example: Channel 1 was allocated and prepared as slave_sg, used and freed. Now preparation of cyclic dma on channel 1 will fail with err "DMA
> configuration conflict" because tdc->isr_handler still selected to handle_once_dma_done.
>
> This happens because tegra_dma_abort_all() won't be called on channel freeing if pending list is empty.
>
> Signed-off-by: Dmitry Osipenko<digetx@gmail.com>

Looks good to me.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

