Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1KCN2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:28:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41058 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1KCN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:28:43 -0400
Date: Thu, 3 Nov 2011 06:25:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 09/28] rcu: Document failing tick as
 cause of RCU CPU stall warning
Message-ID: <20111103132550.GX2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103030750.GB2042@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103030750.GB2042@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110313-1976-0000-0000-000000B20E36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 08:07:50PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:30PM -0700, Paul E. McKenney wrote:
> > One of lclaudio's systems was seeing RCU CPU stall warnings from idle.
> > These turned out to be caused by a bug that stopped scheduling-clock
> > tick interrupts from being sent to a given CPU for several hundred seconds.
> 
> Out of curiosity, what caused this bug?

If I remember correctly, software/configuration bugs in the clock code.

							Thanx, Paul

