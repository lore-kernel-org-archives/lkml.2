Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab0HECjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:39:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42280 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717Ab0HECjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:39:44 -0400
Date: Wed, 4 Aug 2010 19:39:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805023939.GA2987@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100801054816.GI2470@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm>
 <20100804185520.GA2417@srcf.ucam.org>
 <201008042251.08266.rjw@sisk.pl>
 <20100804205654.GA4986@srcf.ucam.org>
 <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 03:08:33PM -0700, Arve Hjønnevåg wrote:
> On Wed, Aug 4, 2010 at 1:56 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

[ . . . ]

> > having this conversation? :) It'd be good to have some feedback from
> > Google as to whether this satisfies their functional requirements.
> 
> That is "this"? The merged code? If so, no it does not satisfy our
> requirements. The in kernel api, while offering similar functionality
> to the wakelock interface, does not use any handles which makes it
> impossible to get reasonable stats (You don't know which pm_stay_awake
> request pm_relax is reverting). The proposed in user-space interface
> of calling into every process that receives wakeup events before every
> suspend call is also not compatible with existing apps.

I should have asked this earlier...  What exactly are the apps'
compatibility constraints?  Source-level APIs?  Byte-code class-library
invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
words, syscall)?

							Thanx, Paul
