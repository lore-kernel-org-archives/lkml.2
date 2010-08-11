Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0HKTnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:43:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60130 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab0HKTnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:43:32 -0400
Date: Wed, 11 Aug 2010 20:43:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100811194301.GA14509@sirena.org.uk>
References: <20100807061558.GA28087@thunk.org> <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com> <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <AANLkTing0RpAoYstVs1G5v-eZ0q6qGjrGiphUvBdOsaS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTing0RpAoYstVs1G5v-eZ0q6qGjrGiphUvBdOsaS@mail.gmail.com>
X-Cookie: Does the name Pavlov ring a bell?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:25:04PM +0300, Felipe Contreras wrote:
> On Tue, Aug 10, 2010 at 7:45 AM, Paul E. McKenney

> > Android is certainly where suspend blockers originated, and is to the best
> > of my knowledge is still the only platform that uses them. ??But there is
> > a first user of every new mechanism, and for some time that first user
> > will by definition be the only user of that mechanism. ??So the fact
> > that Android is most probably the only user of suspend blockers does
> > not prove anything about whether or not suspend blockers are sensible.

> No, it's the fact that *nobody* else has said: hey, that looks like a
> good idea, we should use that in our mobile platform (or any
> platform).

I don't think lack of external adoption is a terribly useful data point
either way at the minute.  While the feature is controversial a lot of
the OSs will probably hold off on it (because it's effort to handle out
of tree stuff and folks are really busy) and there's not that many out
there which support random externally written packages (which is the
major push for exporting the feature to userspace) in the first place.
