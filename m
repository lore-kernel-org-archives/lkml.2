Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2FYGrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:47:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16999 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2FYGrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:47:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 24 Jun 2012 23:44:41 -0700
Message-ID: <4FE8092D.7050302@nvidia.com>
Date: Mon, 25 Jun 2012 12:16:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: add clk_prepare/clk_unprepare
References: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1340605891-19076-1-git-send-email-pgaikwad@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2012 12:01 PM, Prashant Gaikwad wrote:
> Use clk_prepare/clk_unprepare as required by the generic clk framework.
>
> Signed-off-by: Prashant Gaikwad<pgaikwad@nvidia.com>
> ---
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

