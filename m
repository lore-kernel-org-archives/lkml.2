Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab0HLOJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:09:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45807 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0HLOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:09:32 -0400
Date: Thu, 12 Aug 2010 15:09:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812140903.GB11362@sirena.org.uk>
References: <20100809181638.GI3026@linux.vnet.ibm.com> <AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com> <20100811222854.GJ2516@linux.vnet.ibm.com> <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com> <20100812010612.GL2516@linux.vnet.ibm.com> <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com> <20100812034435.GA7403@linux.vnet.ibm.com> <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com> <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu> <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
X-Cookie: Nice guys don't finish nice.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 02:11:22PM +0300, Felipe Contreras wrote:

> So far, nobody has refuted these:
>  1) opportunistic suspend needs a good behaved user-space to work properly
>  2) if suspend blockers are enabled in a system, *all* user-space must
> implement them to work correctly

For this note that there's a fairly strong expectation that even in a
phone type environment a sane userspace implementation will involve a
very large portion of userspace just totally ignoring suspend blockers.
This means that while it is true that userspace as a whole must have
support for suspend blockers the changes required are substantially less
invasive than you appear to expecting.
