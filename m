Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0GIPaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:30:00 -0400
Received: from stinky.trash.net ([213.144.137.162]:38936 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0GIP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:29:59 -0400
Message-ID: <4C374074.8000103@trash.net>
Date: Fri, 09 Jul 2010 17:29:56 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: xiaoyu Du <tingsrain@gmail.com>, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org, wensong@linux-vs.org,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] lvs sctp protocol handler is incorrectly invoked ip_vs_app_pkt_out
References: <AANLkTikS9SSVT5soWZYmzxeJkR5vO__cuedk7ZgmTx5y@mail.gmail.com> <20100708121319.GC17985@verge.net.au>
In-Reply-To: <20100708121319.GC17985@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.07.2010 14:13, schrieb Simon Horman:
> On Thu, Jul 08, 2010 at 09:55:04AM +0800, xiaoyu Du wrote:
>> lvs sctp protocol handler is incorrectly invoked ip_vs_app_pkt_out
>> Since there's no sctp helpers at present, it does the same thing as
>> ip_vs_app_pkt_in.
>>
>> Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>
> 
> Thanks Xiaoyu.
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> Patrick, please consider applying this.
> nf-next should be sufficient, as according
> to Xiaoyu there aren't actually helpers
> that exercise this code at the moment.

Applied, thanks.

