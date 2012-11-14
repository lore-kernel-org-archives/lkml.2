Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2KNIcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:32:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17000 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2KNIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:32:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Nov 2012 00:32:15 -0800
Message-ID: <50A357D3.9080002@nvidia.com>
Date: Wed, 14 Nov 2012 10:35:31 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2012 15:20, Thierry Reding wrote:
> This commit adds the host1x node along with its children to the Tegra20
> DTSI. Furthermore the OF auxiliary data table is updated to have proper
> names assigned to the platform devices instantiated from the device
> tree. Moreover, the clocks required by host1x and the two display
> controllers are initialized and the pll_d frequency table is completed
> with a few entries to support common HDMI and LVDS display modes.

I tried to add nvhost on top of your patches and I noticed a glitch.

> +       { "host1x",     "pll_c",        144000000,      false },

This line causes host1x not to operate correctly. I don't know why this
is so, but when I try to initialize host1x, it hangs with this change,
but everything works without this line.

If you could fix that,

Acked-by: Terje Bergstrom <tbergstrom@nvidia.com>

Best regards,
Terje

