Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2H0NFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:05:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2H0NFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:05:36 -0400
Date: Mon, 27 Aug 2012 09:05:25 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v7 0/4] cgroup: add xattr support
Message-ID: <20120827130525.GI18688@redhat.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
 <20120824225839.GM21325@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824225839.GM21325@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
On Fri, Aug 24, 2012 at 03:58:39PM -0700, Tejun Heo wrote:
> On Thu, Aug 23, 2012 at 04:53:27PM -0400, aris@redhat.com wrote:
> > This series are a refreshed version of a patchset submitted by Li Zefan back
> > in march:
> > 	https://lkml.org/lkml/2012/3/1/13
> 
> Applied to cgroup/for-3.7 w/ "Original-Patch-by: Li Zefan" added for
> the first three patches.
> 
> * Can you please update MTA setting so that the From: header contains
>   your full name?  Importing the series to git ended up with
>   "aris@redhat.com <aris@redhat.com>".

sure, will repost with that fixed and including "Original-Patch-by: Li
Zefan" on the first three patches

> * Can you please add some comments and documentation regarding this?

about what exactly?

-- 
Aristeu

