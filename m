Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2JBRQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:16:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57736 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2JBRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:16:49 -0400
Message-ID: <506B217D.1000003@wwwdotorg.org>
Date: Tue, 02 Oct 2012 11:16:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 17/17] ARM: soc: dependency warnings for errata
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-18-git-send-email-arnd@arndb.de>
In-Reply-To: <1349195816-2225-18-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 10:36 AM, Arnd Bergmann wrote:
> The PL310_ERRATA_753970 and ARM_ERRATA_764369 symbols only make sense
> when the base features for them are enabled, so select them
> conditionally in Kconfig to avoid warnings like:
> 
> warning: (UX500_SOC_COMMON) selects PL310_ERRATA_753970 which has unmet direct dependencies (CACHE_PL310)
> warning: (ARCH_TEGRA_2x_SOC && ARCH_TEGRA_3x_SOC && UX500_SOC_COMMON) selects ARM_ERRATA_764369 which has unmet direct dependencies (CPU_V7 && SMP)

Acked-by: Stephen Warren <swarren@nvidia.com>


