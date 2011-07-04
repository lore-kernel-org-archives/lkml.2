Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1GDJ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:27:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44897 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1GDJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:27:55 -0400
Date: Mon, 4 Jul 2011 17:27:38 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] netpoll: Remove unused EXPORT_SYMBOLs of
 netpoll_poll and netpoll_poll_dev
Message-ID: <20110704092736.GA2932@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>, amwang@redhat.com,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org
References: <cover.1309482314.git.joe@perches.com>
 <282ce7d68b97c4dbfb759c1c0752e6cbddfeeafc.1309482314.git.joe@perches.com>
 <20110704065320.GA2588@gmail.com>
 <1309765589.18925.42.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1309765589.18925.42.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 12:46:29AM -0700, Joe Perches wrote:
[...]
> > You have removed the function declaration in include/linux/netpoll.h.
> 
> Because it's unused by anything in the tree
> but netpoll.c
Hmmmm..., so sorry. I misunderstood your 'unused', which i thought
there was also no use in netpoll.c :-/
> 
> > And you changed the function like 
> > static void netpoll_poll_dev(...)
> > {
> > 	...
> > }
> > But i don't know its usage.
> 
> It's now a local function to netpoll.c
Yeah, it's true.
> 
> > The 'static' before this function just says the active area of 'netpoll_poll_dev'
> > is in the file net/core/netpoll.c. What is the purpose? Could you please tell me?
> 
> It prods the device to perform network work.
> 
> 	/* Process pending work on NIC */
> 	ops->ndo_poll_controller(dev);
> 
> 	poll_napi(dev);
Yeah, i will read the codes.


Thanks so much
Harry Wei
