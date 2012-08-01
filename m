Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2HABgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:36:51 -0400
Received: from tundra.namei.org ([65.99.196.166]:50251 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab2HABgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:36:49 -0400
Date: Wed, 1 Aug 2012 11:34:28 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Paris <eparis@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        linux-security-module@vger.kernel.org, oprofile-list@lists.sf.net,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: Re: [PATCH v3 07/10] mm: use mm->exe_file instead of first VM_EXECUTABLE
 vma->vm_file
In-Reply-To: <20120731104226.20515.76884.stgit@zurg>
Message-ID: <alpine.LRH.2.02.1208011133390.5762@tundra.namei.org>
References: <20120731103724.20515.60334.stgit@zurg> <20120731104226.20515.76884.stgit@zurg>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Konstantin Khlebnikov wrote:

> Some security modules and oprofile still uses VM_EXECUTABLE for retrieving
> task's executable file, after this patch they will use mm->exe_file directly.
> mm->exe_file protected with mm->mmap_sem, so locking stays the same.
> 

Acked-by: James Morris <james.l.morris@oracle.com>




-- 
James Morris
<jmorris@namei.org>
