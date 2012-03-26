Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2CZNJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:09:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2CZNJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:09:51 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=w7xB1nKE_Hj5dOlLTPEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332767386.23924.75.camel@gandalf.stny.rr.com>
Subject: Re: CPU Hotplug rework
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>, paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Mon, 26 Mar 2012 09:09:46 -0400
In-Reply-To: <1332748920.16159.65.camel@twins>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 10:02 +0200, Peter Zijlstra wrote:
> On Mon, 2012-03-26 at 11:11 +1030, Rusty Russell wrote:
> > Obviously, having callbacks hanging around until the CPU comes back is
> > not viable, nor is blocking preempt during the callbacks.  Calling
> > get_online_cpus() is too heavy. 
> 
> -rt has patches (albeit somewhat ugly) to make get_online_cpus() a br
> style rw-lock. 

Unfortunately, -rt still has broken cpu hotplug.

-- Steve


