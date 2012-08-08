Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab2HHK01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:26:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13353 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2HHK0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:26:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 08 Aug 2012 03:26:12 -0700
Message-ID: <50223B3F.1010906@nvidia.com>
Date: Wed, 8 Aug 2012 15:41:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 0/4] i2c: tegra: required clock support for controller
References: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012 01:21 PM, Laxman Dewangan wrote:
> The Tegra's i2c controller required two clock sources for proper
> operation named as div-clk and fast-clk.
>
> Adding support to make sure that driver will get these clocks and
> enable before any transfer and disable after transfer completed.
>
> Patch 1 add the entry of fast clock in clock table.
> Patch 2 modify i2c driver to get the div and fast clock.
> Patch 3 name the connection of the clock entry.
> Patch 4 removes non-required entry from tegra20 clock table.

Hi Wolfram/Stephen,
This patch series very much depends on the common clock changes happens 
on Tegra tree and I think it should go in Tegra common clock tree.

Thanks,
Laxman
