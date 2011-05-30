Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1E3Jns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:43:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:46451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab1E3Jnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:43:46 -0400
Date: Mon, 30 May 2011 11:43:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Patch] mm: remove noswapaccount kernel parameter
Message-ID: <20110530094337.GF20166@tiehlicka.suse.cz>
References: <BANLkTinLvqa0DiayLOwvxE9zBmqb4Y7Rww@mail.gmail.com>
 <20110523112558.GC11439@tiehlicka.suse.cz>
 <BANLkTi=2SwKFfwBxrQr3xLYSUzoGOy6oKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=2SwKFfwBxrQr3xLYSUzoGOy6oKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23-05-11 19:50:21, Am??rico Wang wrote:
> On Mon, May 23, 2011 at 7:25 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Mon 23-05-11 19:08:08, Am??rico Wang wrote:
> >> noswapaccount is deprecated by swapaccount=0, and it is scheduled
> >> to be removed in 2.6.40.
> >
> > Similar patch is already in the Andrew's tree
> 
> Ah, my google search failed to find it. :-/
> 
> > (memsw-remove-noswapaccount-kernel-parameter.patch). Andrew, are you
> > going to push it?
> > Btw. the patch is missing documentation part which is present here.
> >
> 
> Hmm, maybe I should send a delta patch... Andrew?

Have you reposted that patch? The primary patch which removes the
paramter already hit the Linus tree (a2c8990a).

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
