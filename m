Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0KAFu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 01:50:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29581 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0KAFu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 01:50:56 -0400
Date: Mon, 1 Nov 2010 06:40:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
In-Reply-To: <20101031173336.GA28141@balbir.in.ibm.com>
Message-ID: <alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net> <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com> <20101031173336.GA28141@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010, Balbir Singh wrote:

> * MinChan Kim <minchan.kim@gmail.com> [2010-10-31 08:34:01]:
> 
> > On Sun, Oct 31, 2010 at 6:35 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > Hi,
> > >
> > > We can avoid doing a memset in swap_cgroup_swapon() by using vzalloc().
> > >
> > >
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> > 
> > There are so many placed need vzalloc.
> > Thanks, Jesper.
> 
> Yes, please check memcontrol.c as well
> 
I will shortly, I'm slowly working my way through a mountain of code 
checking for this. I'll get to memcontrol.c

> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>  
Thanks.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

