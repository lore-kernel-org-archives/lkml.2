Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab0GEInI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:43:08 -0400
Received: from stinky.trash.net ([213.144.137.162]:39791 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0GEInF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:43:05 -0400
Message-ID: <4C319B18.10409@trash.net>
Date: Mon, 05 Jul 2010 10:43:04 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Michal Marek <mmarek@suse.cz>, lvs-devel@vger.kernel.org,
       netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
       Wensong Zhang <wensong@linux-vs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Kconfig cleanup
References: <1278102728-20217-1-git-send-email-mmarek@suse.cz> <20100704070516.GA9437@verge.net.au> <20100704071347.GB9437@verge.net.au>
In-Reply-To: <20100704071347.GB9437@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> [ Added Patrick McHardy to CC ]
>
> On Sun, Jul 04, 2010 at 04:05:16PM +0900, Simon Horman wrote:
>   
>> On Fri, Jul 02, 2010 at 10:32:08PM +0200, Michal Marek wrote:
>>     
>>> IP_VS_PROTO_AH_ESP should be set iff either of IP_VS_PROTO_{AH,ESP} is
>>> selected. Express this with standard kconfig syntax.
>>>
>>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>>>       
>> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks.
