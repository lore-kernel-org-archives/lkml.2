Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571Ab0HMP5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:57:42 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:54975 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755034Ab0HMP5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:57:40 -0400
Date: Fri, 13 Aug 2010 17:57:38 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, david@lang.hm, Theodore Tso <tytso@mit.edu>,
        peterz@infradead.org, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
        galibert@pobox.com, florian@mickler.org, menage@google.com,
        linux-pm@lists.linux-foundation.org, swmike@swm.pp.se,
        tglx@linutronix.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        arjan@infradead.org
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
	take three
Message-ID: <20100813155738.GA11507@isilmar-3.linta.de>
Mail-Followup-To: Felipe Contreras <felipe.contreras@gmail.com>,
	paulmck@linux.vnet.ibm.com, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
	Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
	James.Bottomley@suse.de, galibert@pobox.com, florian@mickler.org,
	menage@google.com, linux-pm@lists.linux-foundation.org,
	swmike@swm.pp.se, tglx@linutronix.de,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
References: <20100812010612.GL2516@linux.vnet.ibm.com> <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com> <20100812034435.GA7403@linux.vnet.ibm.com> <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com> <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu> <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com> <20100812174303.GD2524@linux.vnet.ibm.com> <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com> <20100813152254.GD2511@linux.vnet.ibm.com> <AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
> >> user-space seems to be having this problem. I can argue to you that
> >> this problem can be solved in easier ways, but instead I will argue
> >> that perhaps we should wait for somebody besides Android to complain
> >> about it before providing a "solution". Because after all, what good
> >> is a "solution" provided by the kernel, if the user-space is not going
> >> to use it, ever.
> >
> > At this point in the discussion, I am quite prepared to believe that you
> > will avoid using suspend blockers, and that you will further do everything
> > in your power to prevent anyone else from using suspend blockers.  ;-)
> 
> I'm not tying anybody's hands.
> 
> How are people using real-time linux if it's not on mainline? Well,
> duuh, you apply the patches. If say Fedora was interested on it, they
> could apply the patches, and see for themselves. People do that all
> the time, with the mm tree, with Con Koliva's patches, etc. Once
> people are happy with the results, things get merged. Why should this
> be any different?

Because millions of users are happy -- with Android, including suspend
blockers.

Best,
	Dominik
