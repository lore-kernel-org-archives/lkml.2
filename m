Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2C0DF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:05:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2C0DFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:05:24 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=_D6bx_0x8lNCu6SoVkQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332817521.23924.122.camel@gandalf.stny.rr.com>
Subject: Re: CPU Hotplug rework
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
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
Date: Mon, 26 Mar 2012 23:05:21 -0400
In-Reply-To: <87iphqbzgw.fsf@rustcorp.com.au>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins>
	 <1332767386.23924.75.camel@gandalf.stny.rr.com>
	 <1332769098.16159.111.camel@twins>
	 <1332775340.23924.102.camel@gandalf.stny.rr.com>
	 <1332778438.16159.136.camel@twins>
	 <1332781541.23924.110.camel@gandalf.stny.rr.com>
	 <87iphqbzgw.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 12:02 +1030, Rusty Russell wrote:

> PS.  And I'm sure you'll finish the work while I'm on honeymoon :)

I'll be getting ready for Linux Collaboration. But have fun on your
honeymoon, and congrats!

-- Steve



