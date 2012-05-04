Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab2EDVjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:39:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35159 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759798Ab2EDVjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:39:22 -0400
Date: Fri, 4 May 2012 14:30:11 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
Message-ID: <20120504213010.GD3054@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
 <1336159496.6509.51.camel@twins>
 <4FA434E9.6000305@linux.vnet.ibm.com>
 <1336162456.6509.63.camel@twins>
 <20120504204627.GB18177@linux.vnet.ibm.com>
 <1336164981.6509.72.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336164981.6509.72.camel@twins>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050421-3534-0000-0000-00000814BF96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2012 [22:56:21 +0200], Peter Zijlstra wrote:
> On Fri, 2012-05-04 at 13:46 -0700, Nishanth Aravamudan wrote:
> > What about other users of cpusets (what are they?)? 
> 
> cpusets came from SGI, its traditionally used to partition _large_
> machines. Things like the batch/job-schedulers that go with that type of
> setup use it.

Yeah, I recall that usage (or some description similar). Do we have any
other known users of cpusets (beyond libvirt)?

> I've no clue why libvirt uses it (or why one would use libvirt for that
> matter).

Well, it is the case that libvirt does use it, and libvirt is used
pretty widely (or so it seems to me). I don't use it (cpusets or libvirt
:) either, but it seems like we should either tell libvirt directly that
cpusets are inappropriate for their use-case (once we figure out what
exactly that is, and why they chose cpusets) or work with them to
support their use-case?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

