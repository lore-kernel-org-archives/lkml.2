Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2HTTAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:00:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab2HTTAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:00:46 -0400
Date: Mon, 20 Aug 2012 15:00:39 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Message-ID: <20120820190039.GR25353@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
 <20120816195831.GF24861@google.com>
 <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> Yes, it looks nice to me.  I might have preferred more as inlines in
> the header file to lower the slight init/evict overhead, and I don't
> see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> of that matters:
> 
> Acked-by: Hugh Dickins <hughd@google.com>

I can submit additional patches to fix these. What functions you want
inlined?

On why __simple_xattr_set() is not using simple_xattr_alloc(), there's
no reason to be that way, I missed it.

Thanks for reviewing!

-- 
Aristeu

