Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab2HWToc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:44:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35635 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2HWTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:44:28 -0400
Date: Thu, 23 Aug 2012 12:44:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <lpoetter@redhat.com>, aris@redhat.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Message-ID: <20120823194423.GC14962@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
 <20120816200006.GG24861@google.com>
 <50340110.50607@redhat.com>
 <20120821214856.GC32596@google.com>
 <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

On Tue, Aug 21, 2012 at 04:29:53PM -0700, Hugh Dickins wrote:
> Are we expecting Aristeu+Zefan's simple_xattr patches to go into 3.7?

Yeah, probably.

> I don't have anything planned for shmem.c for 3.7 beyond a bugfix,
> which shouldn't interact with the simple_xattr changes at all
> (I could remove info->lock, but will not do so this time around,
> precisely so as not to interfere with those patches).
> 
> So it should be perfectly workable for you to take Aristeu+Zefan's
> shmem patches into your cgroup tree, then any further mods from
> mmotm will get layered on top.

I think this approach would be simpler.  Once Aristeu posts the
updated version, I'll route the whole series through cgroup/for-3.7.

Thanks.

-- 
tejun
