Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600Ab0HMQTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:19:31 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:48441 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754564Ab0HMQTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:19:30 -0400
Date: Fri, 13 Aug 2010 18:19:28 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Joe Perches <joe@perches.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, paulmck@linux.vnet.ibm.com,
        david@lang.hm, Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de, galibert@pobox.com, florian@mickler.org,
        menage@google.com, linux-pm@lists.linux-foundation.org,
        swmike@swm.pp.se, tglx@linutronix.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
	take three
Message-ID: <20100813161928.GA16898@isilmar-3.linta.de>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	paulmck@linux.vnet.ibm.com, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
	Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
	James.Bottomley@suse.de, galibert@pobox.com, florian@mickler.org,
	menage@google.com, linux-pm@lists.linux-foundation.org,
	swmike@swm.pp.se, tglx@linutronix.de,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
References: <20100812034435.GA7403@linux.vnet.ibm.com> <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com> <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu> <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com> <20100812174303.GD2524@linux.vnet.ibm.com> <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com> <20100813152254.GD2511@linux.vnet.ibm.com> <AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com> <20100813155738.GA11507@isilmar-3.linta.de> <1281715607.15486.102.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281715607.15486.102.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 09:06:47AM -0700, Joe Perches wrote:
> On Fri, 2010-08-13 at 17:57 +0200, Dominik Brodowski wrote:
> > Because millions of users are happy -- with Android, including suspend
> > blockers.
> 
> I'd guess there are on the order of 20 users
> that have built and deployed a kernel with
> Android suspend blockers support.

You mean non-Google users?

> The total deployed systems is relatively meaningless.

Well, it wasn't meaningless wrt noveau:

"I've heard all the excuses. If it isn't ready, they shouldn't ship it to
millions of people. And if it's ready, they should work on merging it.

No excuses.

Linus"

So let's get the suspend blockers to Linus.

Best
	Dominik
