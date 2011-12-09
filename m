Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1LIBFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:05:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41541 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1LIBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:05:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Dec 2011 10:04:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>
Subject: Re: [PATCH v8 0/9] per-cgroup tcp memory pressure controls
Message-Id: <20111209100420.feaef96a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EDF48A9.6090306@parallels.com>
References: <1323120903-2831-1-git-send-email-glommer@parallels.com>
	<4EDF48A9.6090306@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 09:06:17 -0200
Glauber Costa <glommer@parallels.com> wrote:

> On 12/05/2011 07:34 PM, Glauber Costa wrote:
> > Hi,
> >
> > This is my new attempt to fix all the concerns that were raised during
> > the last iteration.
> >
> > I should highlight:
> > 1) proc information is kept intact. (although I kept the wrapper functions)
> >     it will be submitted as a follow up patch so it can get the attention it
> >     deserves
> > 2) sockets now hold a reference to memcg. sockets can be alive even after the
> >     task is gone, so we don't bother with between cgroups movements.
> >     To be able to release resources more easily in this cenario, the parent
> >     pointer in struct cg_proto was replaced by a memcg object. We then iterate
> >     through its pointer (which is cleaner anyway)
> >
> > The rest should be mostly the same except for small fixes and style changes.
> >
> 
> Kame,
> 
> Does this one address your previous concerns?
> 
Your highlight seems good. I'll look into details.

Thanks,
-Kame

