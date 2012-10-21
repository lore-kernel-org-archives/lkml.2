Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2JUTRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:17:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2JUTRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:17:44 -0400
Date: Sun, 21 Oct 2012 21:18:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
	regardless of freezer state and update locking
Message-ID: <20121021191853.GB26218@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <2424755.Pg0O5tTD3k@vostro.rjw.lan> <20121019200421.GO13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019200421.GO13370@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Tejun Heo wrote:
>
> On Fri, Oct 19, 2012 at 06:54:42PM +0200, Rafael J. Wysocki wrote:
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-locking
> >
> > It seems that no one has any comments. :-)
> >
> > Are you going to prepare a branch for me to pull from?
>
> I'm waiting for Oleg to poke some holes in the synchronization
> department but if that doesn't happen you can pull from the above
> branch.  I'll pull it into cgroup/for-3.8 too.

Just in case, I see nothing bad ;)

But let me repeat I never understood this code in details, and I
already forget everything.

Oleg.

