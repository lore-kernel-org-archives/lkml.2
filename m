Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2BYVrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:47:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34328 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2BYVq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:46:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.132.102 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Sun, 26 Feb 2012 06:46:41 +0900
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120225214641.GB3401@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120225034432.GA18391@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120225034432.GA18391@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 24, 2012 at 10:44:32PM -0500, Vivek Goyal wrote:
> Booting with blkcg-stacking branch and changing io scheduler from cfq to
> deadline oopsed.
> 
> login: [   67.382768] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   67.383037] CPU 1 
> [   67.383037] Modules linked in: floppy [last unloaded: scsi_wait_scan]
> [   67.383037] 
> [   67.383037] Pid: 4763, comm: bash Not tainted 3.3.0-rc3-tejun-misc+ #6 Hewlett-Packard HP xw6600 Workstation/0A9Ch
> [   67.383037] RIP: 0010:[<ffffffff81311793>]  [<ffffffff81311793>] cfq_put_queue+0xb3/0x1d0

Hmmm... weird.  Looking into it.  I'm away from office for a week and
will probably be slow.

Thanks.

-- 
tejun
