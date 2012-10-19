Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab2JSUEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:04:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56274 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2JSUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:04:36 -0400
Date: Fri, 19 Oct 2012 13:04:21 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Message-ID: <20121019200421.GO13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <2424755.Pg0O5tTD3k@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2424755.Pg0O5tTD3k@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 06:54:42PM +0200, Rafael J. Wysocki wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-locking
> 
> It seems that no one has any comments. :-)
> 
> Are you going to prepare a branch for me to pull from?

I'm waiting for Oleg to poke some holes in the synchronization
department but if that doesn't happen you can pull from the above
branch.  I'll pull it into cgroup/for-3.8 too.

Thanks.

-- 
tejun
