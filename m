Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1GLUAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:00:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25066 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1GLUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:00:12 -0400
Date: Tue, 12 Jul 2011 15:57:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712195731.GB20811@dumpdata.com>
References: <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
 <20110712141228.GA7831@dumpdata.com>
 <20110712144936.GD2326@linux.vnet.ibm.com>
 <20110712160324.GA1186@dumpdata.com>
 <20110712163947.GF2326@linux.vnet.ibm.com>
 <20110712180151.GA18257@dumpdata.com>
 <20110712185907.GJ2326@linux.vnet.ibm.com>
 <1310497836.14978.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310497836.14978.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E1CA738.000D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:10:36PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 11:59 -0700, Paul E. McKenney wrote:
> > OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
> > are deferred until after the scheduler is fully initialized.  Sounds like
> > one for the scheduler guys.  ;-) 
> 
> https://lkml.org/lkml/2011/7/12/150

Such a simple patch. And yes, it fixes the issue. You can add
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> if it hasn't yet
showed up in Ingo's tree.

Paul, thanks for help on this and providing ideas to test!
