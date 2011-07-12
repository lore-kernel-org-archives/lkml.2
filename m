Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1GLTLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:11:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1GLTLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:11:14 -0400
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org, chengxu@linux.vnet.ibm.com
In-Reply-To: <20110712185907.GJ2326@linux.vnet.ibm.com>
References: <20110711171337.GK2245@linux.vnet.ibm.com>
	 <20110711193021.GA2996@dumpdata.com>
	 <20110711201508.GN2245@linux.vnet.ibm.com>
	 <20110711210954.GA15745@dumpdata.com>
	 <20110712105506.GB2253@linux.vnet.ibm.com>
	 <20110712141228.GA7831@dumpdata.com>
	 <20110712144936.GD2326@linux.vnet.ibm.com>
	 <20110712160324.GA1186@dumpdata.com>
	 <20110712163947.GF2326@linux.vnet.ibm.com>
	 <20110712180151.GA18257@dumpdata.com>
	 <20110712185907.GJ2326@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Jul 2011 21:10:36 +0200
Message-ID: <1310497836.14978.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 11:59 -0700, Paul E. McKenney wrote:
> OK, so the infinite loop in task_waking_fair() happens even if RCU callbacks
> are deferred until after the scheduler is fully initialized.  Sounds like
> one for the scheduler guys.  ;-) 

https://lkml.org/lkml/2011/7/12/150

?
