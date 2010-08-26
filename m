Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0HZAcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:32:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35955 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab0HZAcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:32:09 -0400
Date: Thu, 26 Aug 2010 09:32:05 +0900
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: julia@diku.dk, wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] net/netfilter/ipvs: Eliminate memory leak
Message-ID: <20100826003204.GA9771@verge.net.au>
References: <Pine.LNX.4.64.1008241639300.15172@ask.diku.dk>
 <20100825013443.GC7237@verge.net.au>
 <20100825.163812.242150096.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825.163812.242150096.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 04:38:12PM -0700, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Wed, 25 Aug 2010 10:34:43 +0900
> 
> > On Tue, Aug 24, 2010 at 04:39:49PM +0200, Julia Lawall wrote:
> >> Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > Thanks Julia, that looks good to me.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > Patrick, I guess that this should go through nf-next-2.6.
> 
> Since Patrick appears to be offline, I'll apply this directly so
> he has less to do when he comes back online :)

I have a handful of other changes queued up,
do you want to take them too?

