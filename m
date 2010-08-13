Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597Ab0HMQGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:06:54 -0400
Received: from mail.perches.com ([173.55.12.10]:1067 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0HMQGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:06:50 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
From: Joe Perches <joe@perches.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, paulmck@linux.vnet.ibm.com,
        david@lang.hm, Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de, galibert@pobox.com, florian@mickler.org,
        menage@google.com, linux-pm@lists.linux-foundation.org,
        swmike@swm.pp.se, tglx@linutronix.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
In-Reply-To: <20100813155738.GA11507@isilmar-3.linta.de>
References: <20100812010612.GL2516@linux.vnet.ibm.com>
	 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	 <20100812034435.GA7403@linux.vnet.ibm.com>
	 <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	 <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	 <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	 <20100812174303.GD2524@linux.vnet.ibm.com>
	 <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	 <20100813152254.GD2511@linux.vnet.ibm.com>
	 <AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com>
	 <20100813155738.GA11507@isilmar-3.linta.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 09:06:47 -0700
Message-ID: <1281715607.15486.102.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 17:57 +0200, Dominik Brodowski wrote:
> Because millions of users are happy -- with Android, including suspend
> blockers.

I'd guess there are on the order of 20 users
that have built and deployed a kernel with
Android suspend blockers support.

The total deployed systems is relatively meaningless.

