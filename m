Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab2FTSoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:44:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42689 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2FTSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:44:16 -0400
Message-ID: <4FE219FD.4070307@wwwdotorg.org>
Date: Wed, 20 Jun 2012 12:44:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: ccross@android.com, olof@lixom.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, bandik@nvidia.com
Subject: Re: [PATCH V2] ARM: tegra: apbio access using dma for tegra20 only
References: <1340195794-26571-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340195794-26571-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 06:36 AM, Laxman Dewangan wrote:
> The Tegra20 HW issue with accessing APBIO registers (such
> as fuse registers) directly from the CPU concurrently with
> APB DMA accesses has been fixed in Tegra30 and later chips.
> 
> Access these registers directly from the CPU on Tegra30
> and later, and apply the workaround only for Tegra20.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Thanks, applied.
