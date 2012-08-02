Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2HBBB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 21:01:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab2HBBB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 21:01:27 -0400
Date: Wed, 1 Aug 2012 21:00:42 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: John David Anglin <dave.anglin@bell.net>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc7
In-Reply-To: <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl>
Message-ID: <Pine.LNX.4.64.1208012054450.6361@file.rdu.redhat.com>
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
 <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
 <4FB0197F.6010000@linux.vnet.ibm.com> <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl>
 <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 May 2012, John David Anglin wrote:

> On 13-May-12, at 4:40 PM, John David Anglin wrote:
> 
> > Yes, the revised change fixes the compilation error.  I'll know in a while
> > if
> > my config boots.
> 
> 
> I successfully booted 3.4-rc7 with this change on rp3440 (4 cpu smp).  My
> build also
> included cache and other fixes that are being discussed on the parisc list.
> 
> Dave

Hi David

Can I download a series of your PA-RISC patches somewhere?

I applied this http://www.spinics.net/lists/linux-parisc/msg03352.html and 
it improved stability for me (I had no gcc crashes since that, only 
about two aptitude crashes).

How stable is it for you? Do you have some random crashes or not?

Mikulas
