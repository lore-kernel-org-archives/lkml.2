Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab2EEEja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:39:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36384 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751171Ab2EEEj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:39:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8oEFOdWn8WLhGtpfVVd1kgM+WKXGQEbFiP5ZqVb
	uj4BsFxLCSFAmc
Message-ID: <1336192753.7339.7.camel@marge.simpson.net>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, rob@landley.net, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Date: Sat, 05 May 2012 06:39:13 +0200
In-Reply-To: <1336164981.6509.72.camel@twins>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
	 <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com>
	 <1336162456.6509.63.camel@twins>
	 <20120504204627.GB18177@linux.vnet.ibm.com>
	 <1336164981.6509.72.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 22:56 +0200, Peter Zijlstra wrote: 
> On Fri, 2012-05-04 at 13:46 -0700, Nishanth Aravamudan wrote:
> > What about other users of cpusets (what are they?)? 
> 
> cpusets came from SGI, its traditionally used to partition _large_
> machines. Things like the batch/job-schedulers that go with that type of
> setup use it.

Includes RT on non-dinky boxen -  _large_ + RT I hope to never meet ;-)

-Mike

