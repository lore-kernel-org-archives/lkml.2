Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1ILKcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:32:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1ILKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:32:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Sep 2011 19:31:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        <xemul@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2 6/9] per-cgroup tcp buffers control
Message-Id: <20110912193117.d8f360f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4E6A001C.2040600@parallels.com>
References: <1315369399-3073-1-git-send-email-glommer@parallels.com>
	<1315369399-3073-7-git-send-email-glommer@parallels.com>
	<20110909121206.e1d628d1.kamezawa.hiroyu@jp.fujitsu.com>
	<4E6A001C.2040600@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Sep 2011 09:01:32 -0300
Glauber Costa <glommer@parallels.com> wrote:

> On 09/09/2011 12:12 AM, KAMEZAWA Hiroyuki wrote:
> > On Wed,  7 Sep 2011 01:23:16 -0300
> > Glauber Costa<glommer@parallels.com>  wrote:
> >
> >> With all the infrastructure in place, this patch implements
> >> per-cgroup control for tcp memory pressure handling.
> >>
> >> Signed-off-by: Glauber Costa<glommer@parallels.com>
> >> CC: David S. Miller<davem@davemloft.net>
> >> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
> >> CC: Eric W. Biederman<ebiederm@xmission.com>
> >
> > Hmm, then, kmem_cgroup.c is just a caller of plugins implemented
> > by other components ?
> 
> Kame,
> 
> Refer to my discussion with Greg. How would you feel about it being 
> accounted to a single "kernel memory" limit in memcg?
> 

Hmm, it's argued that 'cgroup is hard to use, it's difficult!!!'.

Then, if implementation is clean, I think it may be good to add
kmem limit to memcg.

Your and Greg's idea is to have

	memory.kmem_limit_in_bytes 
?

Thanks,
-Kame

