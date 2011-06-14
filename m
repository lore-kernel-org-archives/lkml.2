Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1FNPK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:10:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1FNPKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:10:54 -0400
Subject: Re: rcu: performance regression
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: "Alex,Shi" <alex.shi@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, rostedt@goodmis.org
In-Reply-To: <20110614150155.GC2288@linux.vnet.ibm.com>
References: <1308029185.15392.147.camel@sli10-conroe>
	 <1308040388.21027.1847.camel@debian>
	 <20110614130203.GF2264@linux.vnet.ibm.com>
	 <1308057298.19856.40.camel@twins> <1308057522.19856.41.camel@twins>
	 <20110614150155.GC2288@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 17:10:25 +0200
Message-ID: <1308064225.19856.76.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 08:01 -0700, Paul E. McKenney wrote:
> Hmmm...  This is going to be fun for the -rt guys given the mapping of
> softirq and irq to kthreads, but then again, perhaps people will
> confine use of -rt to smaller systems. 

Its those -rt guys that wrote this stuff :-)
