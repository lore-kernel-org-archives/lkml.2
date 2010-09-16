Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0IPFwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:52:35 -0400
Received: from stinky.trash.net ([213.144.137.162]:35560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab0IPFwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:52:33 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 01:52:32 EDT
Message-ID: <4C91AE53.2050901@trash.net>
Date: Thu, 16 Sep 2010 07:42:43 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: horms@verge.net.au, julia@diku.dk, wensong@linux-vs.org, ja@ssi.bg,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] net/netfilter/ipvs: Eliminate memory leak
References: <Pine.LNX.4.64.1008241639300.15172@ask.diku.dk>	<20100825013443.GC7237@verge.net.au> <20100825.163812.242150096.davem@davemloft.net>
In-Reply-To: <20100825.163812.242150096.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.2010 01:38, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Wed, 25 Aug 2010 10:34:43 +0900
> 
>> On Tue, Aug 24, 2010 at 04:39:49PM +0200, Julia Lawall wrote:
>>> Signed-off-by: Julia Lawall <julia@diku.dk>
>>
>> Thanks Julia, that looks good to me.
>>
>> Signed-off-by: Simon Horman <horms@verge.net.au>
>>
>> Patrick, I guess that this should go through nf-next-2.6.
> 
> Since Patrick appears to be offline, I'll apply this directly so
> he has less to do when he comes back online :)

Thanks Dave. I should be done catching up by tonight and will start
taking care of IPVS patches again.
