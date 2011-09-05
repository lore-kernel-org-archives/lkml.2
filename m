Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1IEO3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:29:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1IEO3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:29:11 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Mon, 05 Sep 2011 16:28:24 +0200
In-Reply-To: <20110904193703.GA9775@linux.vnet.ibm.com>
References: <20110830153343.GW9748@somewhere.redhat.com>
	 <1314737918.19586.8.camel@twins>
	 <20110830222432.GD15953@somewhere.redhat.com>
	 <1314782245.23993.9.camel@twins> <20110831133754.GA20598@somewhere>
	 <1314801660.3578.41.camel@twins> <20110901164040.GC2286@linux.vnet.ibm.com>
	 <1314897180.1485.12.camel@twins> <20110902014101.GA2405@linux.vnet.ibm.com>
	 <1314951871.1301.2.camel@twins> <20110904193703.GA9775@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315232904.3191.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sun, 2011-09-04 at 12:37 -0700, Paul E. McKenney wrote:
> 
> But if you don't mind, I would very much like to use your question as
> a Quick Quiz.  It should be a good one.  ;-) 

No problem.. :-)
