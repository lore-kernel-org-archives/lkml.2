Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2LRHFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:05:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12423 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRHFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:05:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 17 Dec 2012 23:03:56 -0800
Message-ID: <50D015B5.8050805@nvidia.com>
Date: Tue, 18 Dec 2012 12:35:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: tegra: add connection name for uart clock table
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com> <1355746101-15291-3-git-send-email-ldewangan@nvidia.com> <50CF9233.3010506@wwwdotorg.org>
In-Reply-To: <50CF9233.3010506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2012 03:14 AM, Stephen Warren wrote:
> On 12/17/2012 05:08 AM, Laxman Dewangan wrote:
>> Add connection name "uart-clk" for the uart clock information.
> Does the UART receive more than one clock, so that it actually cares
> what the clock connection name is? If not, can we just drop this patch?

I like to have this patch because:
- In future, I want to also get the name of the clock source and set 
parent of uart clock properly.
- I want to switch the parent clock source dynamically between CLKM and 
PLLP to achieve more power optimization i.e. use CLKM wherever possible..
