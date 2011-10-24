Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1JXMLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:11:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57317 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab1JXMLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:11:03 -0400
Date: Mon, 24 Oct 2011 05:10:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 42/55] rcu: Make rcu_torture_fqs() exit
 loops at end of test
Message-ID: <20111024121048.GE2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-42-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111017015329.GG19421@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017015329.GG19421@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102412-3534-0000-0000-000000DB4ED8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 06:53:29PM -0700, Josh Triplett wrote:
> On Tue, Sep 06, 2011 at 11:00:36AM -0700, Paul E. McKenney wrote:
> > The rcu_torture_fqs() function can prevent the rcutorture tests from
> > completing, resulting in a hang.  This commit therefore ensures that
> > rcu_torture_fqs() will exit its inner loops at the end of the test,
> > and also applies the newish ULONG_CMP_LT() macro to time comparisons.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This seems like two entirely separate changes, which should go in
> separate commits.

Interesting.  I was thinking of this as fixing hangs in rcutorture,
and was feeling somewhat bad about having the separate commit for the
part of the fix that I missed.  ;-)

							Thanx, Paul

