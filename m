Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1IUReT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:34:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45358 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1IUReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:34:18 -0400
Date: Wed, 21 Sep 2011 23:04:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110921173411.GA6794@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931775.5977.29.camel@twins>
 <20110913175425.GB3062@linux.vnet.ibm.com>
 <1315937995.4226.9.camel@twins>
 <20110913182841.GO11100@linux.vnet.ibm.com>
 <1315938646.4226.12.camel@twins>
 <20110913183502.GP11100@linux.vnet.ibm.com>
 <20110915175537.GA17701@linux.vnet.ibm.com>
 <1316523320.13664.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1316523320.13664.2.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-20 14:55:20]:

> On Thu, 2011-09-15 at 23:25 +0530, Kamalesh Babulal wrote:
> 
(snip)
> > rm -rf test*
> > rm -rf t*
> 
> You're insane, right?

Ofcourse not :-). It's a typo. it should have been 
rm -rf r* to delete the temporary files created by 
the original script (Only the part which does the
se.nr_migrations calculation was posted). 

> > ITERATIONS=60			# No of Iterations to capture the details
> > NUM_CPUS=$(cat /proc/cpuinfo |grep -i proces|wc -l)
> > 
> > NUM_HOGS=$((NUM_CPUS * 2))	# No of hogs threads to invoke
> > 
(snip)
> > for i in $(seq 1 $NUM_HOGS)
> > do
> > 	./while$i &
> 
> You can kill the above two blocks by doing:
> 
> 	while :; do :; done &

Thanks. Got to knew this from your commit 866ab43efd325fae88 previously.

Thanks,
Kamalesh.
