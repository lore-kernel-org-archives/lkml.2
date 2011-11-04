Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1KDPQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:16:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50883 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1KDPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:16:38 -0400
Date: Fri, 4 Nov 2011 08:16:31 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com
Subject: Re: [PATCH 02/10] threadgroup: rename
 signal->threadgroup_fork_lock to ->group_rwsem
Message-ID: <20111104151631.GW4417@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-3-git-send-email-tj@kernel.org>
 <20111104174032.e0c4fc11.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104174032.e0c4fc11.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 05:40:32PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue,  1 Nov 2011 16:46:25 -0700
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Make the following renames to prepare for extension of threadgroup
> > locking.
> > 
> > * s/signal->threadgroup_fork_lock/signal->group_rwsem/
> > * s/threadgroup_fork_read_lock()/threadgroup_change_begin()/
> > * s/threadgroup_fork_read_unlock()/threadgroup_change_done()/
> 
> I personally like begin <-> end to see relationship.

Hmmm... yeah, I like that better too.  Renaming.

Thanks.

-- 
tejun
