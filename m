Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2CLXi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:38:58 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36748 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2CLXiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:38:54 -0400
Date: Mon, 12 Mar 2012 16:38:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, tj@kernel.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
Message-ID: <20120312233845.GJ2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
 <1331048093.11248.317.camel@twins>
 <20120308195825.GC2412@linux.vnet.ibm.com>
 <1331374193.18960.13.camel@twins>
 <20120312175432.GF2471@linux.vnet.ibm.com>
 <1331575097.18960.40.camel@twins>
 <20120312183203.GH2471@linux.vnet.ibm.com>
 <1331583916.18960.56.camel@twins>
 <20120312231532.GI2471@linux.vnet.ibm.com>
 <1331594319.18960.68.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331594319.18960.68.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031223-3270-0000-0000-000004BD74B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:18:39AM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 16:15 -0700, Paul E. McKenney wrote:
> > We need rcu_barrier() in order to be able to safely unload modules
> > that
> > use call_rcu(). 
> 
> Oh, right.. I always forget about modules. 

Lucky you!  ;-)

(Sorry, couldn't resist...)

							Thanx, Paul

