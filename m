Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2DEVqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:46:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2DEVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:46:38 -0400
Date: Thu, 5 Apr 2012 14:46:34 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120405214634.GB29517@google.com>
References: <1333601231.7783.31.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
 <1333608177.7783.106.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
 <20120405213704.GA29517@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405213704.GA29517@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 02:37:04PM -0700, Tejun Heo wrote:
> look of the current users, I don't think it's gonna be hard.  cpu
> cgroup would have to learn to ignore tasks with special scheduling
> class and the blkcg silliness needs to go away but that seems to be
> it.

Ooh, right, cgroup-freezer needs to learn how to move tasks across
cgroups in different states but that has been in the plan for some
time now.

Thanks.

-- 
tejun
