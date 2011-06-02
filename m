Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1FBOwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:52:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1FBOwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:52:40 -0400
Date: Thu, 2 Jun 2011 16:52:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Patch] mm: remove the leftovers of noswapaccount
Message-ID: <20110602145239.GC6820@tiehla.suse.cz>
References: <BANLkTinLvqa0DiayLOwvxE9zBmqb4Y7Rww@mail.gmail.com> <20110523112558.GC11439@tiehlicka.suse.cz> <BANLkTi=2SwKFfwBxrQr3xLYSUzoGOy6oKA@mail.gmail.com> <20110530094337.GF20166@tiehlicka.suse.cz> <20110602141622.GA4416@cr0.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110602141622.GA4416@cr0.redhat.com>
User-Agent: Mutt/1.5.18-muttng (2008-05-17-r1399)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-06-11 22:16:22, Américo Wang wrote:
> 
> In commit a2c8990aed5ab (memsw: remove noswapaccount kernel parameter),
> Michal forgot to remove some left pieces of noswapaccount in the tree,
> this patch removes them all.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Michal Hocko <mhocko@suse.cz>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
