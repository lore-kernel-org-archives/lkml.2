Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3AGRDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:03:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48370 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3AGRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:03:51 -0500
Message-ID: <50EAFFF3.4050600@wwwdotorg.org>
Date: Mon, 07 Jan 2013 10:03:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, djbw@fb.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: add support for Tegra114 SoC
References: <1357387568-26010-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357387568-26010-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 05:06 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has APB DMA controller which supports channel wise
> pause control. The global pause is used for clock gating and hence
> DMA registers are not accessible if DMAs are globally disabled.
> 
> Add support for use of channel wise pause feature for Tegra114 SOCs.

Aside from the comments already made by Vinod,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
