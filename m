Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2LTGRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:17:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17879 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2LTGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:16:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 19 Dec 2012 22:15:19 -0800
Message-ID: <50D2AD59.8070901@nvidia.com>
Date: Thu, 20 Dec 2012 11:46:57 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra30: tegra30 gpio is not compatible with tegra20
 gpio
References: <1355929032-26549-1-git-send-email-ldewangan@nvidia.com> <50D1F385.7000506@wwwdotorg.org>
In-Reply-To: <50D1F385.7000506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012 10:34 PM, Stephen Warren wrote:
> On 12/19/2012 07:57 AM, Laxman Dewangan wrote:
>> tegra30 gpio controller is not compatible with the tegra20 due to
>> their bank stride i.e. Tegra20 bank stride is 0x80 where Tegra30
>> bank stride is 0x100.
> Thanks, I've been meaning to clean this up for a while, but never got
> around to it. I can apply after the merge window is closed; I don't
> think it's important enough to warrant going into 3.8 or earlier, since
> it doesn't cause any active problems.
>
> Have you checked all the other devices to make sure they're all correct to?

Not yet, I  am going one by one for finding if anything we are missing 
on IO drivers or not and then came across this.

