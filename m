Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2DNL2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:28:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2DNL2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:28:40 -0400
Message-ID: <1334402900.2528.69.camel@twins>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Date: Sat, 14 Apr 2012 13:28:20 +0200
In-Reply-To: <alpine.DEB.2.00.1204061337570.23328@chino.kir.corp.google.com>
References: <20120405160829.GA12854@google.com>
	 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
	 <20120405213704.GA29517@google.com>
	 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
	 <20120405222400.GC29517@google.com>
	 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
	 <20120405225854.GE29517@google.com>
	 <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
	 <20120405231306.GF29517@google.com>
	 <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
	 <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
	 <alpine.DEB.2.00.1204061337570.23328@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 13:46 -0700, David Rientjes wrote:
> That doesn't work, the kmem extension to memcg does not allow slab to be 
> properly accounted to threads in the root memcg.  From 
> Documentation/cgroups/memory.txt section 2.7:
> 
> "Kernel memory limits are not imposed for the root cgroup. Usage for the 
> root cgroup may or may not be accounted." 

To me that reads like: kmem/memcg is broken.
