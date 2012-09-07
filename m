Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab2IGG4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:56:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8205 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2IGG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:56:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Sep 2012 23:56:41 -0700
Message-ID: <504994FF.2070706@nvidia.com>
Date: Fri, 7 Sep 2012 12:02:31 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>, "djbw@fb.com" <djbw@fb.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] dma: tegra: use list_move_tail instead of list_del/list_add_tail
References: <CAPgLHd9DHDY9-oxFRK6coarc8JqKGporKSXTFG5fkRioZz6xFw@mail.gmail.com>
In-Reply-To: <CAPgLHd9DHDY9-oxFRK6coarc8JqKGporKSXTFG5fkRioZz6xFw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012 12:38 PM, Wei Yongjun wrote:
> From: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
>
> Using list_move_tail() instead of list_del() + list_add_tail().
>
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
> ---
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
Looks good to me.

