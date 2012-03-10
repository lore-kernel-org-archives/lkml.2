Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2CLR0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:26:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab2CLR0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:26:46 -0400
Message-ID: <1331374349.18960.15.camel@twins>
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
        patches@linaro.org
Date: Sat, 10 Mar 2012 11:12:29 +0100
In-Reply-To: <20120308194905.GB2412@linux.vnet.ibm.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331031498.11248.273.camel@twins>
	 <CACvQF53k9TQfPnVYA3DPeQbwqiA+4+Q5SqQ2dJSFQFAVmodD3Q@mail.gmail.com>
	 <1331048298.11248.320.camel@twins>
	 <20120308194905.GB2412@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 11:49 -0800, Paul E. McKenney wrote:
> 
> I too have used (long)(a - b) for a long time, but I saw with my own eyes
> the glee in the compiler-writers' eyes when they discussed signed overflow
> being undefined in the C standard.  I believe that the reasons for signed
> overflow being undefined are long obsolete, but better safe than sorry. 

Thing is, if they break that the whole kernel comes falling down, I
really wouldn't worry about RCU at that point. But to each their
pet-paranoia I guess ;-)
