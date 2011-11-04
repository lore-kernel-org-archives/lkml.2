Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1KDCh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:37:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59948 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1KDChy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:37:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 11:36:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mk@cm4all.com,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        nishimura@mxp.nes.nec.co.jp, oleg@redhat.com,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>, tj@kernel.org,
        cgroups@vger.kernel.org, akpm@linux-foundation.org, fweisbec@gmail.com,
        paul@paulmenage.org
Subject: Re: [PATCH] add new cgroup list to CC notice
Message-Id: <20111104113646.5c0e9be6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EB3495B.8080700@free.fr>
References: <20111104094030.cf8d5860.kamezawa.hiroyu@jp.fujitsu.com>
	<4EB3495B.8080700@free.fr>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Nov 2011 03:09:31 +0100
Daniel Lezcano <daniel.lezcano@free.fr> wrote:

> On 11/04/2011 01:40 AM, KAMEZAWA Hiroyuki wrote:
> > As discussed at Kernel Summit(2011), new cgroups mailing list is opened by
> > James. This list is for discussing general cgroup design and patches
> > including all subsystems and for getting more attentions to cgroups/namespaces
> > related issues by developpers.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> 
> I don't see the point to unilaterally change the mailing list to 
> vger.kernel.org as the discussions will be  the same as the actual 
> mailing list containers@. May be there is a good reason to do that but I 
> don't see it, can someone enlight me please ?
> 
I know containers@ and subscribing it.

Maybe this article is good.
http://lwn.net/Articles/464288/

I think there are cgroups not-for-container but total view/interaction
are required. someones may use cgroup just as resource controller (as libvirt,
systemd) and not be intereted in container itself.

I personally think cgroups@ is a straightforward name to kernel developpers. 

Thanks,
-Kame

