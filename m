Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2FNNBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:01:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:52729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2FNNBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:01:38 -0400
Message-ID: <1339678887.2559.30.camel@twins>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jun 2012 15:01:27 +0200
In-Reply-To: <20120614125939.GC2443@linux.vnet.ibm.com>
References: <20120613102823.373180763@linutronix.de>
	 <20120613105815.206105518@linutronix.de>
	 <20120613185748.GF2427@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206132101440.3086@ionos>
	 <20120613191745.GG2427@linux.vnet.ibm.com>
	 <20120613204725.GA9858@linux.vnet.ibm.com>
	 <20120614045125.GA30257@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206141234400.3086@ionos>
	 <20120614125939.GC2443@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 05:59 -0700, Paul E. McKenney wrote:
> Yep, starvation.

What's the particular starvation case?
