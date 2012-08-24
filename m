Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab2HXNOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2HXNOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:14:44 -0400
Date: Fri, 24 Aug 2012 09:14:35 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v7 1/4] xattr: extract simple_xattr code from tmpfs
Message-ID: <20120824131435.GC18688@redhat.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
 <20120823205327.613311683@napanee.usersys.redhat.com>
 <alpine.LSU.2.00.1208231609240.5904@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208231609240.5904@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 04:14:24PM -0700, Hugh Dickins wrote:
> I'm also happy to see that you're now using simple_xattr_alloc() in
> __simple_xattr_set() (but no need to respin to comment on that here).
> 
> It looks very nice: much better for this code to live in fs/xattr.c
> than in mm/shmem.c.

Thanks for the review and feedback!

-- 
Aristeu

