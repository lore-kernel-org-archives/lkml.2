Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1I1KpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:45:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39568 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1I1KpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:45:04 -0400
Date: Wed, 28 Sep 2011 12:45:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
Message-ID: <20110928104506.GB22878@gere.osrc.amd.com>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
 <1317068164.1763.39.camel@twins>
 <1317076065.3112.539.camel@work-vm>
 <1317119870.15383.29.camel@twins>
 <1317164216.3112.711.camel@work-vm>
 <1317201399.18012.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317201399.18012.4.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:16:39AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> > 
> > 
> > I do think my idea is neat, so we can spend/burn time debating it, but
> > if you have viable suggestions (and honestly, I think rewriting all of
> > userland isn't viable) on solving the larger problem, I'm all ears.
> > 
> And yet, rewriting all of userspace is exactly what Android did, they
> had the perfect opportunity of doing it right, but they came up with the
> worst solution ever.
> 
> As for my laptop, I really would like the firefox guys to add a
> 'feature' that stops JS on non-visible tabs and preferably also drop all
> data after a little while.
> 
> firefox is the #1 wakeup thing on my machine and its mostly invisible
> (minimized) and when its not, I can only stare at a single tab anyway.

Oh yeah, same here.

I even went so far as to do

kill -STOP $(pidof firefox-bin)

at times simply because the thing was getting out of control. And to be
honest, the moment a thinner browser comes out with authors who actually
do care about not bloating the crap out of it, I'm jumping on it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
