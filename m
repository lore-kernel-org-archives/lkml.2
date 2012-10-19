Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2JSVHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:07:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55925 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2JSVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:07:43 -0400
Date: Fri, 19 Oct 2012 14:07:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
Message-ID: <20121019210738.GA1180@google.com>
References: <20121008020000.GB2575@localhost>
 <20121019005922.GG13370@google.com>
 <CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
 <20121019193808.GL13370@google.com>
 <CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Fri, Oct 19, 2012 at 03:44:20PM -0400, Frederic Weisbecker wrote:
> > For -stable, I think it's better to revert.  If you want to remove
> > task_lock, let's do it for 3.8.
> 
> I don't think that a wrong comment justifies a patch to stable.

I'm not really sure whether it's safe or not.  It seems all usages are
protected by write locking css_set_lock but maybe I'm missing
something and as the commit is born out of confusion, I'm very
inclined to revert it by default.  Are you sure this one is safe?

Thanks.

-- 
tejun
