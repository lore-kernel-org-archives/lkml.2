Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2DFHui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:50:38 -0400
Received: from szxga03-in.huawei.com ([58.251.152.66]:34857 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2DFHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:50:37 -0400
Date: Fri, 06 Apr 2012 15:50:14 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
In-reply-to: <20120405214634.GB29517@google.com>
X-Originating-IP: [10.166.88.103]
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Message-id: <4F7EA036.6040909@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <1333601231.7783.31.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
 <1333608177.7783.106.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
 <20120405213704.GA29517@google.com> <20120405214634.GB29517@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> On Thu, Apr 05, 2012 at 02:37:04PM -0700, Tejun Heo wrote:
>> look of the current users, I don't think it's gonna be hard.  cpu
>> cgroup would have to learn to ignore tasks with special scheduling
>> class and the blkcg silliness needs to go away but that seems to be
>> it.
> 
> Ooh, right, cgroup-freezer needs to learn how to move tasks across
> cgroups in different states but that has been in the plan for some
> time now.
> 


What do you plan to do with cpusets? cpuset.cpus and cpuset.mems are
empty when a cgroup is created, and thus task attaching will fail.

