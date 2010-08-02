Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0HBOMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:12:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35419 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0HBOMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:12:43 -0400
Date: Mon, 2 Aug 2010 07:12:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802141224.GC2405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <20100801200655.7edcf247@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801200655.7edcf247@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 08:06:55PM -0700, Arjan van de Ven wrote:
> On Sun, 1 Aug 2010 18:10:06 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > If I understand you correctly, a key point of agreement between you
> > and the Android guys is that both the system and the user have some
> > say over how applications are treated by the system in terms of how
> > seriously the system takes a given application's requests.
> > 
> > The Android guys also want the user to have some say about what
> > applications are permitted to have some control over "I want to go to
> > <this magic deep idle state>" requests.  Does that seem reasonable
> > to you?
> 
> I personally think it's one of those things where... well we can get a
> LONG way automatically (by just observing things); asking the users
> is very very often just caving in rather than solving the problem.
> 
> Asking the user should only be done for things the user
> 1) Can give an intelligent answer to
> and
> 2) Are something the user WANTS to be involved in.
>    (rather than 'stupid thing, why don't just do the right thing'..
>    think the Windows Vista security questions)

Combining this with your previous email, I believe that you are saying
that it is necessary for the user to be able to exert some control,
but that the UI design had better be sufficiently intelligent with
sufficiently good defaults that the user almost never actually -needs-
to exert such control.

If this is indeed what you are saying, I certainly agree.

							Thanx, Paul
