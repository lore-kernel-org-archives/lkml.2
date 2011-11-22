Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1KVQUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:20:25 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab1KVQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:20:22 -0500
Date: Tue, 22 Nov 2011 08:20:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org,
        oleg@redhat.com, kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCHSET] cgroup: stable threadgroup during attach & subsys
 methods consolidation
Message-ID: <20111122162013.GD3250@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <20111121220719.GP25776@google.com>
 <4ECB089C.3080208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB089C.3080208@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:27:40AM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> > On Tue, Nov 01, 2011 at 04:46:23PM -0700, Tejun Heo wrote:
> >> This patchset is combination of the following two patchsets.
> >>
> >>  [1] cgroup: extend threadgroup locking
> >>  [2] cgroup: introduce cgroup_taskset and consolidate subsys methods, take#2
> > 
> > Li, do you agree with the proposed patches?  If so, I'll wait for
> > Frederic's response, repost updated series and merge it into the
> > cgroup tree.
> > 
> 
> I remember I've acked both patchsets in your earlier post. :)

Heh, right, it has been too long and I forgot.  I'll add the acks.

Thank you.

-- 
tejun
