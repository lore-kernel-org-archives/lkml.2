Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688Ab0HLDoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:44:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49535 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758947Ab0HLDox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:44:53 -0400
Date: Wed, 11 Aug 2010 20:44:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812034435.GA7403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100808155719.GB3635@thunk.org>
 <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
 <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com>
 <AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
 <20100811222854.GJ2516@linux.vnet.ibm.com>
 <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
 <20100812010612.GL2516@linux.vnet.ibm.com>
 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 04:25:21AM +0300, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 4:06 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Aug 12, 2010 at 03:28:00AM +0300, Felipe Contreras wrote:
> >> On Thu, Aug 12, 2010 at 1:28 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Wed, Aug 11, 2010 at 10:18:51PM +0300, Felipe Contreras wrote:
> >> >> On Mon, Aug 9, 2010 at 9:16 PM, Paul E. McKenney
> >> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >> > But wouldn't an office suite run as a power-oblivious application on an
> >> >> > Android device?  After all, office applications do not need to run when
> >> >> > the screen is turned off, so these the applications do not need to use
> >> >> > suspend blockers.
> >> >>
> >> >> Ideally the system would be suspended even when the screen is on. If
> >> >> there are no "trusted" applications running at the same time, then
> >> >> openoffice wouldn't load at all. Right?
> >> >
> >> > My understanding is that Android systems in fact do not suspend when
> >> > the screen is on, and that most (perhaps all) other systems do not
> >> > opportunistically suspend at all.  There has been some speculation about
> >> > what a hypothetical Android having a non-volatile display might do,
> >> > but as far as I know, this is just speculation.
> >>
> >> I have a desktop system in mind. If opportunistic suspend is only
> >> triggered when the display is off, then it's no good for normal usage,
> >> and therefore dynamic PC needs to get its act together... specially
> >> for laptops.
> >
> > If I understand you correctly, you are saying that both opportunistic
> > suspend and dynamic power control should be used together, with dynamic
> > power control being used for short non-busy periods (as in between
> > keystrokes) and opportunistic suspend being used for longer non-busy
> > periods (as in while grabbing a coffee).  That combination of usage
> > sounds promising to me.
> 
> No. In the future x86 will be fixed, but for now let's imagine an ARM laptop.

Hmmm...  OK...

> > That said, I don't know that anyone has really sat down and thought
> > through how one might apply suspend blockers to a desktop system.
> > I suspect that there are several ways to go about it.
> 
> Think in terms of an ARM laptop. What good is opportunistic suspend if
> it's not going to help when the laptop is being used?

For when the laptop is not being used, presumably.

							Thanx, Paul
