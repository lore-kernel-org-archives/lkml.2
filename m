Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1JJRnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:43:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62078 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1JJRnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:43:31 -0400
Date: Mon, 10 Oct 2011 10:43:27 -0700
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org,
        Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/4] cgroup: change locking order in
 attach_task_by_pid()
Message-ID: <20111010174327.GH8100@google.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <1315159280-25032-2-git-send-email-htejun@gmail.com>
 <20110918185621.GB6159@redhat.com>
 <20111010173426.GG8100@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010173426.GG8100@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:34:26AM -0700, Tejun Heo wrote:
> > And, this means we can't change cpuset_do_move_task() to do
> > threadgroup_lock().
> 
> Would that be problematic?

Ooh, looking through other users of cgroup_attach_task().  Yeah, some
of them can be problematic.  I'll write more in another reply.

Thanks.

-- 
tejun
