Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3AECpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:45:55 -0500
Received: from [216.228.121.35] ([216.228.121.35]:2727 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3AECpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:45:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 Jan 2013 18:44:55 -0800
Message-ID: <50E793A0.4020702@nvidia.com>
Date: Sat, 5 Jan 2013 08:14:48 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "linux@prisktech.co.nz" <linux@prisktech.co.nz>,
        "josh.cartwright@ni.com" <josh.cartwright@ni.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] clk: tegra: Use common of_clk_init() function
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com> <1357282858-2112-2-git-send-email-pgaikwad@nvidia.com> <50E703A8.1080808@wwwdotorg.org>
In-Reply-To: <50E703A8.1080808@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2013 10:00 PM, Stephen Warren wrote:
> On 01/04/2013 12:00 AM, Prashant Gaikwad wrote:
>> Use common of_clk_init() function for clocks initialization.
>>   drivers/clk/tegra/clk-tegra20.c |    3 ++-
>>   drivers/clk/tegra/clk-tegra30.c |    3 ++-
> Oh, so this series is written assuming that the Tegra CCF rework is
> already applied then? That makes the dependencies quite painful, since I
> think we'll end up with the following order being needed:
>
> 1) clk: Add composite clock type
>     -> This would usually go through the clk tree.
> 2) The Tegra CCF rework series
>     -> This must go through the Tegra tree due to lots of dependencies
>     and merge conflicts with other Tegra patches.
> 3) This series
>     -> This would usually go through the clk tree.
>
> Is it possible to re-order the dependencies as (1) (3) (2), so that Mike
> can apply (1) and (3) to the clock tree, then I can use the clk tree as
> the basis for a branch in the Tegra tree to apply (2) and all the other
> Tegra patches that will conflict with (2)?

If Mike approves the concept and implementation in (1) and (3) then I 
will repost (2) and (3) with dependencies re-ordered.


