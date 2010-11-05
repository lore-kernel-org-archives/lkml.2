Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0KEPZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:25:38 -0400
Received: from mail.perches.com ([173.55.12.10]:4308 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0KEPZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:25:36 -0400
Subject: Re: [PATCH 46/49] net/netfilter: Use vzalloc
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011051108270.15851@pobox.suse.cz>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <7d6da34b7e84955795717b0241000a0701cd5b34.1288925425.git.joe@perches.com>
	 <1288938640.3234.12.camel@edumazet-laptop>
	 <1288940146.18440.55.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1011051108270.15851@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 08:25:34 -0700
Message-ID: <1288970734.18440.103.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 11:10 -0400, Jiri Kosina wrote:
> On Thu, 4 Nov 2010, Joe Perches wrote:
> > I also think a single rolled-up single patch is good.
> > I believe Jiri Kosina can easily apply all these individual patches as a 
> > single patch if he chooses.
> I will, after this settles a little bit (the same for the WARN series). 
> I prefer waiting a bit before applying your patches usually. 
> First to see what lands in linux-next through maintainer's trees, second 
> to gather Acks.

I think that's the right way to do these
sorts of trivial changes too.

Individual patches cc'd to maintainers for
feedback, improvement, acks or to be directly
applied to their trees, followed by a longish
delay before any unapplied patches are taken
up as a single patch by your trivial queue.

Thanks for doing that work Jiri.


