Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2BJEV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 23:21:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4969 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2BJEV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 23:21:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Feb 2012 20:21:47 -0800
Message-ID: <4F349B59.6070104@nvidia.com>
Date: Thu, 09 Feb 2012 20:21:45 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>
Subject: Re: [PATCH] pinctrl: changes hog mechanism to be self-referential
References: <1328834868-25030-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1328834868-25030-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 04:47 PM, Linus Walleij wrote:
> Instead of a specific boolean field to indicate if a map entry shall
> be hogged, treat self-reference as an indication of desired hogging.
> This drops one field off the map struct and has a nice Douglas R.
> Hofstadter-feel to it.
> 
> Suggested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt

> -PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "power_func")
> +PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "pinctrl-foo". "power_func")

That "." should be ",". Other than that,

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic
