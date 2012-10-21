Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2JUTYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:24:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34715 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2JUTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:24:06 -0400
Date: Sun, 21 Oct 2012 12:24:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121021192401.GC5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <2424755.Pg0O5tTD3k@vostro.rjw.lan>
 <20121019200421.GO13370@google.com>
 <20121021191853.GB26218@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021191853.GB26218@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Sun, Oct 21, 2012 at 09:18:53PM +0200, Oleg Nesterov wrote:
> > I'm waiting for Oleg to poke some holes in the synchronization
> > department but if that doesn't happen you can pull from the above
> > branch.  I'll pull it into cgroup/for-3.8 too.
> 
> Just in case, I see nothing bad ;)
> 
> But let me repeat I never understood this code in details, and I
> already forget everything.

Heh, if you can't spot something wrong in the freezer state memory
barrier dancing, I'm happy. :)

Thanks a lot for taking a look.

--
tejun
