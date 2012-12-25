Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2LYJn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 04:43:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4100 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab2LYJny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 04:43:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Dec 2012 01:43:46 -0800
Message-ID: <50D97553.80001@nvidia.com>
Date: Tue, 25 Dec 2012 15:13:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: dts: add aliases and DMA requestor for serial
 controller
References: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com> <50D1F2CB.3090206@wwwdotorg.org> <50D2AD02.6060101@nvidia.com> <50D344E9.70305@wwwdotorg.org> <50D3E320.2090804@nvidia.com> <50D4CBB0.7080603@wwwdotorg.org> <50D614D9.8020106@nvidia.com> <50D93AB6.7040905@wwwdotorg.org>
In-Reply-To: <50D93AB6.7040905@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 December 2012 11:03 AM, Stephen Warren wrote:
> On 12/22/2012 01:15 PM, Laxman Dewangan wrote:
>
>> This way it is straight
>> forward for the uart user to directly see the uart instance on board and
>> decide the port number rather than going to what are other uart and
>> their corresponding driver.
> Still, there is some precedent in the kernel for your approach. So, I
> guess we can go ahead with using the aliases as-is.
>

So can I assume this patch is fine and I need not to re-spin it for 
removing aliases?

