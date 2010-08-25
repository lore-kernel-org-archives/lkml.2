Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0HYXiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:38:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59323
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab0HYXh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:57 -0400
Date: Wed, 25 Aug 2010 16:38:12 -0700 (PDT)
Message-Id: <20100825.163812.242150096.davem@davemloft.net>
To: horms@verge.net.au
Cc: julia@diku.dk, wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] net/netfilter/ipvs: Eliminate memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100825013443.GC7237@verge.net.au>
References: <Pine.LNX.4.64.1008241639300.15172@ask.diku.dk>
	<20100825013443.GC7237@verge.net.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Wed, 25 Aug 2010 10:34:43 +0900

> On Tue, Aug 24, 2010 at 04:39:49PM +0200, Julia Lawall wrote:
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Thanks Julia, that looks good to me.
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Patrick, I guess that this should go through nf-next-2.6.

Since Patrick appears to be offline, I'll apply this directly so
he has less to do when he comes back online :)

Thanks.
