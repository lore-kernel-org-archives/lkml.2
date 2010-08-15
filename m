Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0HOHAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 03:00:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52021 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0HOHAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 03:00:16 -0400
Date: Sun, 15 Aug 2010 00:00:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100815070004.GD2461@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100811222854.GJ2516@linux.vnet.ibm.com>
 <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
 <20100812010612.GL2516@linux.vnet.ibm.com>
 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
 <20100812034435.GA7403@linux.vnet.ibm.com>
 <20100813115751.3bbbafbd@lxorguk.ukuu.org.uk>
 <20100813152912.GE2511@linux.vnet.ibm.com>
 <20100814073843.GA27430@elf.ucw.cz>
 <20100814151048.GA2461@linux.vnet.ibm.com>
 <20100814095351.6a996187@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814095351.6a996187@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 09:53:51AM -0700, Arjan van de Ven wrote:
> On Sat, 14 Aug 2010 08:10:48 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > So once you are down to one CPU, the last CPU shuts the system off,
> > itself included?  Or does the last CPU "run" in a deep idle state
> > throughout suspend?  (My guess is the former, and I am also curious
> > whether the cache SRAMs are powered off, etc.  But figured I should
> > ask rather than guessing.)
> 
> they tend to go "off".
> 
> however I think you're making an assumption that there is a
> real difference between a deep idle state and "off"....
> 
> For modern x86 hardware, that assumption isn't really valid.
> (other than a very very small sram that stores register content in the
> idle case)

I am and have been taking you at your word that some systems can reach
power levels while idle that rival suspended/off.  The differences between
idle and suspend are instead semantic, have been posted here more than
once, and make themselves felt when the non-suspended system is non-idle,
even for systems whose deep-idle power approximates that of suspend/off.

							Thanx, Paul
