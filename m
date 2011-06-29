Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1F2VVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:21:10 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:59912 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751199Ab1F2VVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:21:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Rd7Z6PjPllRtqaCIoqe2v8rnBBOuKiRHG1EXJIevpXeRGK0lGDdD1hIqYGIFouY7dgyvQdVIxHK9zrOJdl0Bc4jypPGT+G2+bWVIWkDI/seH3vCZp+hUDX5X8c4GgBEc;
Date: Wed, 29 Jun 2011 14:21:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>, xfs-masters@oss.sgi.com
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.0-rc5 (xfs on cris)
Message-Id: <20110629142106.447393a5.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:

> *** ERRORS ***
> 
> 698 regressions:

>   + fs/xfs/xfs_log.c: error: 'head' undeclared (first use in this function):  => 104, 130, 837
>   + fs/xfs/xfs_log.c: error: 'struct log' has no member named 'l_grant_reserve_head':  => 1204
>   + fs/xfs/xfs_log.c: error: 'struct log' has no member named 'l_grant_write_head':  => 3436
>   + fs/xfs/xfs_log.c: error: 'struct log' has no member named 'l_iclog_bak':  => 3410, 3409
>   + fs/xfs/xfs_log.c: error: 'struct log' has no member named 'l_last_sync_lsn':  => 806, 1232
>   + fs/xfs/xfs_log.c: error: 'struct log' has no member named 'l_tail_lsn':  => 808, 3437, 1218, 838
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_grant_reserve_head':  => 2591, 2564, 2761, 1019, 2748, 717, 1338, 2807
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_grant_reserve_lock':  => 2551, 2578, 2601, 1023, 2566, 716, 2536, 3709, 2587, 2585, 3706, 730, 2598, 2533
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_grant_write_head':  => 2750, 1020, 697, 2808, 2708, 2592, 1339, 2682, 2653
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_grant_write_lock':  => 2704, 2652, 1024, 2684, 3711, 3714, 696, 2672, 2695, 708, 2718, 2715, 2702, 2675
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_iclog_bak':  => 1100
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_last_sync_lsn':  => 2223, 685, 2221, 1017
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_reserveq':  => 718, 3707, 2535, 711, 2568, 2539, 2532, 1021
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_tail_lsn':  => 689, 1016
>   + fs/xfs/xfs_log.c: error: 'xlog_t' has no member named 'l_writeq':  => 2666, 2649, 2654, 1022, 2663, 2686, 691, 3712, 698
>   + fs/xfs/xfs_log.c: error: (Each undeclared identifier is reported only once:  => 104
>   + fs/xfs/xfs_log.c: error: expected declaration specifiers or '...' before 'atomic64_t':  => 127, 50, 101, 829
>   + fs/xfs/xfs_log.c: error: for each function it appears in.):  => 104
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'atomic64_cmpxchg':  => 120
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'atomic64_read':  => 104
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'atomic64_set':  => 689
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_assign_atomic_lsn':  => 1016
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_assign_grant_head':  => 1019
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_crack_atomic_lsn':  => 838
>   + fs/xfs/xfs_log.c: error: implicit declaration of function 'xlog_crack_grant_head':  => 837
>   + fs/xfs/xfs_log.c: error: too many arguments to function 'xlog_grant_add_space':  => 2591, 2708, 2762, 1339, 2592, 1338
>   + fs/xfs/xfs_log.c: error: too many arguments to function 'xlog_grant_sub_space':  => 2808, 2751, 2749, 2807
>   + fs/xfs/xfs_log.c: error: too many arguments to function 'xlog_space_left':  => 697, 2564, 1204, 2682, 717, 2653
>   + fs/xfs/xfs_log_recover.c: error: 'xlog_t' has no member named 'l_grant_reserve_head':  => 970
>   + fs/xfs/xfs_log_recover.c: error: 'xlog_t' has no member named 'l_grant_write_head':  => 972
>   + fs/xfs/xfs_log_recover.c: error: 'xlog_t' has no member named 'l_last_sync_lsn':  => 1020, 969
>   + fs/xfs/xfs_log_recover.c: error: 'xlog_t' has no member named 'l_tail_lsn':  => 968, 1003, 1018
>   + fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'atomic64_read':  => 1003
>   + fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'atomic64_set':  => 968
>   + fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'xlog_assign_atomic_lsn':  => 1018
>   + fs/xfs/xfs_log_recover.c: error: implicit declaration of function 'xlog_assign_grant_head':  => 970


Looks like arch/cris does not support atomic64_t.  (?)

Should we prevent xfs from being built on arch/cris?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
