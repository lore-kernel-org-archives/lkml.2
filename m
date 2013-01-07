Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3AGRBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:01:41 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57093 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3AGRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:01:39 -0500
Message-ID: <50EAFF70.70709@wwwdotorg.org>
Date: Mon, 07 Jan 2013 10:01:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: w.sang@pengutronix.de, swarren@nvidia.com, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: add support for Tegra114 SoC
References: <1357387486-25966-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357387486-25966-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 05:04 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has following enhanced feature in i2c controller:
> - Enable/disable control for per packet transfer complete interrupt.
>   Earlier SoCs could not disable this.
> - Single clock source for standard/fast and HS mode clock speed.
>   The clock divisor for fast/standard mode is added into the i2c
>   controller to meet the HS and standard/fast mode of clock speed
>   from single source.
> 
> Add support for the above feature to make it functional on T114 SOCs.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

