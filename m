Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504Ab0HMKq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:46:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50311 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761456Ab0HMKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:46:25 -0400
Date: Fri, 13 Aug 2010 11:30:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
        galibert@pobox.com, florian@mickler.org, menage@google.com,
        swmike@swm.pp.se, linux-pm@lists.linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, arjan@infradead.org
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
Message-ID: <20100813113033.4bf911b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20100812195224.GA6370@comet.dominikbrodowski.net>
References: <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812174303.GD2524@linux.vnet.ibm.com>
	<AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	<AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
	<20100812195224.GA6370@comet.dominikbrodowski.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess I don't, either -- there are some parts of the kernel used by only a
> handful of users... and here we speak about million users...

Because in general the bits for a small user base don't leak out into
other bits of the kernel. It's a much higher barrier if you want to
affect other people's code because it is asking everyone else to help
maintain stuff they don't need.

That's not to say sometimes its not the right choice, but I still find it
remarkable that nobody else but Android seems to want it,.
Alan
