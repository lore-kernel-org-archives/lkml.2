Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1A0BHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:07:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54528 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab1A0BHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:07:40 -0500
Message-ID: <4D40C5A3.4070703@cn.fujitsu.com>
Date: Thu, 27 Jan 2011 09:08:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup : remove the ns_cgroup
References: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr> <20110126161837.43830756.akpm@linux-foundation.org>
In-Reply-To: <20110126161837.43830756.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-27 09:07:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-27 09:07:01,
	Serialize complete at 2011-01-27 09:07:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 25 Jan 2011 10:39:48 +0100
> Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> 
>> This patch removes the ns_cgroup as suggested in the following thread:
> 
> I had this patch queued up in September last year, but dropped it.  Why
> did I do that?

Because you wanted to wait for some time for users (if any) to notice this
coming change.

Author: Daniel Lezcano <daniel.lezcano@free.fr>
Date:   Wed Oct 27 15:33:38 2010 -0700

    cgroup: notify ns_cgroup deprecated
    
    The ns_cgroup will be removed very soon.  Let's warn, for this version,
    ns_cgroup is deprecated.
    
    Make ns_cgroup and clone_children exclusive.  If the clone_children is set
    and the ns_cgroup is mounted, let's fail with EINVAL when the ns_cgroup
    subsys is created (a printk will help the user to understand why the
    creation fails).
    
    Update the feature remove schedule file with the deprecated ns_cgroup.
    
    Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
    Acked-by: Paul Menage <menage@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
