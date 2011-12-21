Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1LURvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:51:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37115 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1LURvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:51:54 -0500
Date: Wed, 21 Dec 2011 09:51:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 2/2 v2] cgroup: Drop task_lock(parent) on cgroup_fork()
Message-ID: <20111221175149.GH9213@google.com>
References: <1324432958-20414-1-git-send-email-fweisbec@gmail.com>
 <1324432958-20414-3-git-send-email-fweisbec@gmail.com>
 <4EF14176.9040206@cn.fujitsu.com>
 <20111221024849.GC17668@somewhere>
 <4EF14F7B.2040507@cn.fujitsu.com>
 <20111221175024.GG9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221175024.GG9213@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 09:50:24AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 21, 2011 at 11:16:11AM +0800, Li Zefan wrote:
> > So I'll ack this patch.
> 
> Do I have your ack on the first one too?  If so, I'll go ahead and
> apply these two.

Ooh, you already did in the previous posting.  Applying to
cgroup/for-3.3.

Thanks.

-- 
tejun
