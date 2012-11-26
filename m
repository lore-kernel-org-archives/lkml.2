Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2KZVAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:00:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56965 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2KZVAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:00:21 -0500
Message-ID: <50B3D861.7050700@wwwdotorg.org>
Date: Mon, 26 Nov 2012 14:00:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arm: tegra: select correct parent clk for pll_p
References: <1353396556-7738-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1353396556-7738-1-git-send-email-sivaramn@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 12:29 AM, Sivaram Nair wrote:
> For Tegra30, pll_p clk's parent is wrongly specified as clk_m instead of
> pll_ref in the tegra30_clk_init_table and this is resulting in a
> boot-time warning. This patch fixes this by correcting the clk init
> table.

Thanks, applied.

