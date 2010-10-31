Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0JaRdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:33:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41439 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0JaRdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:33:43 -0400
Date: Sun, 31 Oct 2010 23:03:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
Message-ID: <20101031173336.GA28141@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
 <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2010-10-31 08:34:01]:

> On Sun, Oct 31, 2010 at 6:35 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > Hi,
> >
> > We can avoid doing a memset in swap_cgroup_swapon() by using vzalloc().
> >
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> There are so many placed need vzalloc.
> Thanks, Jesper.

Yes, please check memcontrol.c as well


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
