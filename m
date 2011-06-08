Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1FHANQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:13:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49391 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab1FHANP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:13:15 -0400
Date: Tue, 7 Jun 2011 17:13:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] Fix mismatched variable in rcutree_trace.c
Message-ID: <20110608001313.GI2286@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
 <1307485593-27196-2-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.02.1106080040320.11814@ionos>
 <20110607231306.GH2286@linux.vnet.ibm.com>
 <20110607234356.GA27166@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607234356.GA27166@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:43:56AM +0200, Andi Kleen wrote:
> > Hmmm...  Some arches have signed CPU numbers while others have unsigned
> > CPU numbers.  I do use "-1" to mean "no CPU" in some cases (for example,
> > in rcu_node_kthread_setaffinity()), so I guess for consistency I should
> > be using "int" everywhere.
> 
> Do I hear that "int" is ok for you? If yes I will not revise the patch
> and please merge it.  If it needs changes please let me know.

Yep, "int" is OK.  I queued your patch and am testing it now.

Thank you for catching this!

							Thanx, Paul
