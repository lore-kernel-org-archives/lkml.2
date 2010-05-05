Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab0EEAEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:04:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55097 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab0EEAEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:04:49 -0400
Date: Tue, 4 May 2010 17:04:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH tip/core/rcu 33/48] cgroups: __rcu annotations
Message-ID: <20100505000443.GJ2639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-33-git-send-email-paulmck@linux.vnet.ibm.com>
 <m2v6599ad831005041348le3a2373fmab4626bd51cfc698@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2v6599ad831005041348le3a2373fmab4626bd51cfc698@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 01:48:10PM -0700, Paul Menage wrote:
> On Tue, May 4, 2010 at 1:19 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Paul Menage <menage@google.com>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> 
> Acked-by: Paul Menage <menage@google.com>

Thank you, Paul!

							Thanx, Paul
