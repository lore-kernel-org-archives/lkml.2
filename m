Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2EDU4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:56:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43185 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab2EDU4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:56:45 -0400
Message-ID: <1336164981.6509.72.camel@twins>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 04 May 2012 22:56:21 +0200
In-Reply-To: <20120504204627.GB18177@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
	 <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com>
	 <1336162456.6509.63.camel@twins>
	 <20120504204627.GB18177@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 13:46 -0700, Nishanth Aravamudan wrote:
> What about other users of cpusets (what are they?)? 

cpusets came from SGI, its traditionally used to partition _large_
machines. Things like the batch/job-schedulers that go with that type of
setup use it.

I've no clue why libvirt uses it (or why one would use libvirt for that
matter).
