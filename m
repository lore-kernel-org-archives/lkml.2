Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab2JYRLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab2JYRLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:11:36 -0400
Date: Thu, 25 Oct 2012 19:12:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [PATCH 0/1] (Was: cgroup_freezer: don't stall transition to FROZEN
	for PF_NOFREEZE or PF_FREEZER_SKIP tasks)
Message-ID: <20121025171236.GA6776@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org> <20121022183453.GA24687@redhat.com> <20121022211822.GF5951@atj.dyndns.org> <20121023155533.GC16201@redhat.com> <20121024190651.GC12182@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024190651.GC12182@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Tejun Heo wrote:
>
> > I'd prefer to simply clear PF_NOFREEZE (without set_freezable), but
> > obviously this doesn't look exactly right from cgroup_freezer pov.
>
> I don't think it matters all that much.  It's a pretty special case.

OK.

> Maybe define PF_CLEAR_ON_EXEC_MASK or something and just include
> PF_NOFREEZE in it?

May be... but it will have a single user and sched.h is already huge,
so didn't do this.

Oleg.

