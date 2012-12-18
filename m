Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2LRNFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:05:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9546 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2LRNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:05:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Dec 2012 05:05:36 -0800
Message-ID: <50D06A21.2000102@nvidia.com>
Date: Tue, 18 Dec 2012 18:35:37 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: tegra30: Add support for Uart clock source divider
 as 15.1
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com> <1355746101-15291-2-git-send-email-ldewangan@nvidia.com> <50CF91F7.5010402@wwwdotorg.org> <50D009E0.3050409@nvidia.com> <50D00C1D.9090100@nvidia.com> <50D0163F.3030806@nvidia.com>
In-Reply-To: <50D0163F.3030806@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2012 12:37 PM, Prashant Gaikwad wrote:
> On Tuesday 18 December 2012 11:54 AM, Laxman Dewangan wrote:
>> On Tuesday 18 December 2012 11:44 AM, Prashant Gaikwad wrote:
>>>
>>> My clock driver rework includes this fix. Divider supports both DIVU71
>>> and DIVU151.
>>> UART divider is set to DIVU151.
>> Prashant,
>> I like to go this patch as first patch towards bug fixes rather than
>> after moving the clock. The reason is that we will pull this change in
>> our downstream and will be available in our K3.7 code.
> Laxman,
>
> We are not going to use ccf in our downstream kernel port to K3.7. How
> does that help pushing in upstream?

Ok, as per our internal discussion, I am going to drop first three 
patches. I will relookinto these patches once your series get applied 
and will work if there is any missing items.


Stephen,
I will respin the 4th patch based on how the discussion on serial driver 
goes. I will send the new patch for 4th change.


