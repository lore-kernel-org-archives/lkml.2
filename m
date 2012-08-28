Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2H1QP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:15:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35435 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2H1QPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:15:25 -0400
Date: Tue, 28 Aug 2012 09:15:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v7 0/4] cgroup: add xattr support
Message-ID: <20120828161522.GD14812@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
 <20120824225839.GM21325@google.com>
 <20120827130525.GI18688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827130525.GI18688@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 27, 2012 at 09:05:25AM -0400, Aristeu Rozanski wrote:
> Hi Tejun,
> On Fri, Aug 24, 2012 at 03:58:39PM -0700, Tejun Heo wrote:
> > On Thu, Aug 23, 2012 at 04:53:27PM -0400, aris@redhat.com wrote:
> > > This series are a refreshed version of a patchset submitted by Li Zefan back
> > > in march:
> > > 	https://lkml.org/lkml/2012/3/1/13
> > 
> > Applied to cgroup/for-3.7 w/ "Original-Patch-by: Li Zefan" added for
> > the first three patches.
> > 
> > * Can you please update MTA setting so that the From: header contains
> >   your full name?  Importing the series to git ended up with
> >   "aris@redhat.com <aris@redhat.com>".
> 
> sure, will repost with that fixed and including "Original-Patch-by: Li
> Zefan" on the first three patches

Ooh, I already fixed it up myself.  I was mentioning for future
patches.

> > * Can you please add some comments and documentation regarding this?
> 
> about what exactly?

What xattr support in cgroup does and for what supposed purposes with
what kind of restrictions and some comments explaining the
implementation, I suppose.

Thanks.

-- 
tejun
