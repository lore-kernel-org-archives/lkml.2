Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2DEWb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:31:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61701 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2DEWb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:31:27 -0400
Date: Thu, 5 Apr 2012 15:31:24 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120405223124.GD29517@google.com>
References: <1333604949.7783.76.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
 <1333608177.7783.106.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
 <20120405213704.GA29517@google.com>
 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
 <20120405222400.GC29517@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405222400.GC29517@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 03:24:00PM -0700, Tejun Heo wrote:
> at the moment, so it could be possible to support the use case you're
> describing but please bear in mind that such use case might not be of
> high priority.  Hmm... I'll think more about it.

To clarify a bit.  By "such use case", I'm referring to putting
kthreadd into !root cgroup or trying to eliminate (as opposed to
minimizing to a reasonable level, which IMHO should be possible w/o
messing with kthreadd) resource usage from root cgroup.

Thanks.

-- 
tejun
