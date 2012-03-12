Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab2CLXTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:19:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:54654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2CLXTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:19:08 -0400
Message-ID: <1331594319.18960.68.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, tj@kernel.org
Date: Tue, 13 Mar 2012 00:18:39 +0100
In-Reply-To: <20120312231532.GI2471@linux.vnet.ibm.com>
References: <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331032571.11248.277.camel@twins>
	 <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
	 <1331048093.11248.317.camel@twins>
	 <20120308195825.GC2412@linux.vnet.ibm.com>
	 <1331374193.18960.13.camel@twins>
	 <20120312175432.GF2471@linux.vnet.ibm.com>
	 <1331575097.18960.40.camel@twins>
	 <20120312183203.GH2471@linux.vnet.ibm.com>
	 <1331583916.18960.56.camel@twins>
	 <20120312231532.GI2471@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 16:15 -0700, Paul E. McKenney wrote:
> We need rcu_barrier() in order to be able to safely unload modules
> that
> use call_rcu(). 

Oh, right.. I always forget about modules. 
