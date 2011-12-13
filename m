Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1LMCRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:17:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61631 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1LMCRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:17:47 -0500
Date: Mon, 12 Dec 2011 18:17:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paul@paulmenage.org,
        rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED AGAIN 03/10] threadgroup: extend
 threadgroup_lock() to cover exit and exec
Message-ID: <20111213021742.GD25802@google.com>
References: <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
 <20111205184315.GJ627@google.com>
 <20111207153046.GC13252@somewhere.redhat.com>
 <20111207182214.GA7610@google.com>
 <20111208205055.GB12108@google.com>
 <20111209234246.GC27173@somewhere>
 <20111213013334.GC25802@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213013334.GC25802@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patchset published at

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.3

and merged branch also pushed out to for-next.

Thanks.

-- 
tejun
