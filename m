Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992521Ab2JYRg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946136Ab2JYRgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:36:54 -0400
Date: Thu, 25 Oct 2012 19:37:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with
	PF_KTHREAD
Message-ID: <20121025173756.GB7650@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org> <20121022183453.GA24687@redhat.com> <20121022211822.GF5951@atj.dyndns.org> <20121023155533.GC16201@redhat.com> <20121024190651.GC12182@atj.dyndns.org> <20121025171236.GA6776@redhat.com> <20121025171256.GB6776@redhat.com> <20121025172016.GF11442@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025172016.GF11442@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Tejun Heo wrote:
>
> On Thu, Oct 25, 2012 at 07:12:56PM +0200, Oleg Nesterov wrote:
> > flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Probably needs Cc: stable.
>
>   Acked-by: Tejun Heo <tj@kernel.org>

Thanks,

> How should this be routed?  -mm?  Andrew, can you please pick this up?

or perhaps Rafael can take it?

Oleg.

