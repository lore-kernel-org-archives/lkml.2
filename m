Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2GEBK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:10:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15528 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2GEBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:10:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 18:10:54 -0700
Message-ID: <4FF4E996.7010003@nvidia.com>
Date: Thu, 5 Jul 2012 06:40:46 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: Fix cached parent ptrs allocation
References: <1341407737-1016-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1341407737-1016-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2012 06:45 PM, Prashant Gaikwad wrote:
> Compiler optimizes code someway that even if clk->parents
> is not NULL it tries to allocate parents array. Change the
> condition so that compiler does not optimize it in wrong
> way.
>
> Also, initialize i to num_parents to make sure parent
> is searched using parent name if parents is NULL.
>
> Signed-off-by: Prashant Gaikwad<pgaikwad@nvidia.com>
> ---
> Mike,
>
> There could be some other way to fix problem. I have not
> debugged it in detail but I think this simple change should do.
Mike,

Please ignore this patch as Rajendra has already sent patch to fix.

http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=commitdiff;h=863b13271f1608ab3af6f7a371047d9a66693e38

>   drivers/clk/clk.c |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
>

