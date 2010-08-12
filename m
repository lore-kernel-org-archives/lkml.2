Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850Ab0HLT1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:27:44 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:39455 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753158Ab0HLT1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:27:42 -0400
Date: Thu, 12 Aug 2010 21:27:39 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Brian Swetland <swetland@google.com>, peterz@infradead.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, galibert@pobox.com,
        florian@mickler.org, linux-pm@lists.linux-foundation.org,
        paulmck@linux.vnet.ibm.com, James.Bottomley@suse.de,
        tglx@linutronix.de, swmike@swm.pp.se, david@lang.hm,
        Theodore Tso <tytso@mit.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, menage@google.com, arjan@infradead.org
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
	take three
Message-ID: <20100812192739.GA11390@isilmar-3.linta.de>
Mail-Followup-To: Felipe Contreras <felipe.contreras@gmail.com>,
	Brian Swetland <swetland@google.com>, peterz@infradead.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, galibert@pobox.com,
	florian@mickler.org, linux-pm@lists.linux-foundation.org,
	paulmck@linux.vnet.ibm.com, James.Bottomley@suse.de,
	tglx@linutronix.de, swmike@swm.pp.se, david@lang.hm,
	Theodore Tso <tytso@mit.edu>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org, menage@google.com,
	arjan@infradead.org
References: <20100812010612.GL2516@linux.vnet.ibm.com> <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com> <20100812034435.GA7403@linux.vnet.ibm.com> <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com> <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu> <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com> <20100812140903.GB11362@sirena.org.uk> <AANLkTik=K2znpgiHVgA1oD5Znrmm0Gx45ajfoQ7AwG3F@mail.gmail.com> <AANLkTi=9v0o5pQ6s=sjjnk0udmrBAiy4wD+h2vrn_h8=@mail.gmail.com> <AANLkTiniku7rqkio-T6f9tL_adJSrDKfU33wFEEkeMVH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiniku7rqkio-T6f9tL_adJSrDKfU33wFEEkeMVH@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

> If you think suspend blockers are useful for you, great, use them. I
> just don't see why they should be merged if nobody is going to use
> them but you.

Aren't there many drivers in the kernel sources which are only used by very
few users? Android is used by million users, albeit on one platform, but I
don't see this to be a valid reason to keep this functionality out of the
kernel.

Best,
	Dominik
