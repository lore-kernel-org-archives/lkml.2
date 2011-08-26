Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1HZPxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab1HZPxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:53:19 -0400
Date: Fri, 26 Aug 2011 17:50:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bblum@andrew.cmu.edu, fweisbec@gmail.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org
Subject: Re: + cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
	added to -mm tree
Message-ID: <20110826155011.GA18410@redhat.com>
References: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org> <20110826151245.GA16243@redhat.com> <20110826152139.GH2632@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826152139.GH2632@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 08/26, Tejun Heo wrote:
>
> Please take a look at the following series.
>
>   http://thread.gmane.org/gmane.linux.kernel/1184375

OK, thanks... looks like 1/6 conflicts with this patch ;)

Tejun, I'll appreciate if you can send me this thread in mbox format
privately. I don't think I can help, just I am curious.

> attach racing against exit/exec is problematic and maybe we should
> extend task->threadgroup_fork_lock protection to cover both exit and
> exec.  I can't like it tho.

Yes...

Oleg.

