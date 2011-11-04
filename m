Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1KDIlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:41:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54588 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1KDIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:41:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 17:40:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/10] threadgroup: rename signal->threadgroup_fork_lock
 to ->group_rwsem
Message-Id: <20111104174032.e0c4fc11.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1320191193-8110-3-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
	<1320191193-8110-3-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Nov 2011 16:46:25 -0700
Tejun Heo <tj@kernel.org> wrote:

> Make the following renames to prepare for extension of threadgroup
> locking.
> 
> * s/signal->threadgroup_fork_lock/signal->group_rwsem/
> * s/threadgroup_fork_read_lock()/threadgroup_change_begin()/
> * s/threadgroup_fork_read_unlock()/threadgroup_change_done()/

I personally like begin <-> end to see relationship.

> * s/threadgroup_fork_write_lock()/threadgroup_lock()/
> * s/threadgroup_fork_write_unlock()/threadgroup_unlock()/
> 
> This patch doesn't cause any behavior change.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

