Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0KEPK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:10:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:46626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0KEPK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:10:26 -0400
Date: Fri, 5 Nov 2010 11:10:23 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/49] net/netfilter: Use vzalloc
In-Reply-To: <1288940146.18440.55.camel@Joe-Laptop>
Message-ID: <alpine.LNX.2.00.1011051108270.15851@pobox.suse.cz>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>  <7d6da34b7e84955795717b0241000a0701cd5b34.1288925425.git.joe@perches.com>  <1288938640.3234.12.camel@edumazet-laptop> <1288940146.18440.55.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Joe Perches wrote:

> I also think a single rolled-up single patch is good.
> 
> I believe Jiri Kosina can easily apply all these individual patches as a 
> single patch if he chooses.

I will, after this settles a little bit (the same for the WARN series). 
I prefer waiting a bit before applying your patches usually. 

First to see what lands in linux-next through maintainer's trees, second 
to gather Acks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
