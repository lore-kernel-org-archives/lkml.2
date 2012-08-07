Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2HGSls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2HGSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:41:45 -0400
Date: Tue, 7 Aug 2012 14:41:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: John David Anglin <dave.anglin@bell.net>
cc: James.Bottomley@hansenpartnership.com, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc7
In-Reply-To: <BLU0-SMTP1253492C7F871CBBDAC05297CB0@phx.gbl>
Message-ID: <Pine.LNX.4.64.1208071439090.6535@file.rdu.redhat.com>
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
 <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
 <4FB0197F.6010000@linux.vnet.ibm.com> <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl>
 <BLU0-SMTP4CED805E93EF3D8DA2198971A0@phx.gbl> <Pine.LNX.4.64.1208012054450.6361@file.rdu.redhat.com>
 <BLU0-SMTP1253492C7F871CBBDAC05297CB0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Aug 2012, John David Anglin wrote:

> On 1-Aug-12, at 9:00 PM, Mikulas Patocka wrote:
> 
> > 
> > 
> > On Sun, 13 May 2012, John David Anglin wrote:
> > 
> > > On 13-May-12, at 4:40 PM, John David Anglin wrote:
> > > 
> > > > Yes, the revised change fixes the compilation error.  I'll know in a
> > > > while
> > > > if
> > > > my config boots.
> > > 
> > > 
> > > I successfully booted 3.4-rc7 with this change on rp3440 (4 cpu smp).  My
> > > build also
> > > included cache and other fixes that are being discussed on the parisc
> > > list.
> > > 
> > > Dave
> > 
> > Hi David
> > 
> > Can I download a series of your PA-RISC patches somewhere?
> > 
> > I applied this http://www.spinics.net/lists/linux-parisc/msg03352.html and
> > it improved stability for me (I had no gcc crashes since that, only
> > about two aptitude crashes).
> > 
> > How stable is it for you? Do you have some random crashes or not?
> 
> 
> Attached are my latest patch sets for linux-stable 3.4 and 3.5 branches.
> There is no place to to download them directly.  I added Jiri Kosina's
> personality fix today to the 3.5 patch set.  Otherwise, they are similar.
> 
> In general, stability with 3.4 has been pretty good.  I just started testing
> 3.5 a couple of days ago.  I went about three weeks without a random
> crash with 3.4 after I removed Al Viro's restart patch.  It was causing
> problems with irq handling.

Which restart patch do you mean?

> This is on 64-bit rp3440.  I have been using it to build debian unstable
> and test GCC 4.8.  So, the machine gets a fair bit of exercise.  In the last
> little while, it has been pretty easy to keep up with the changes in unstable.
> 
> Sorry, I haven't had time to submit my changes.  Some of the cache fixes
> are a bit hard to explain.
> 
> Dave
> --
> John David Anglin	dave.anglin@bell.net

Thanks. For me the kernel with the patch works fine - it would be nice to 
break it up to smaller pieces and submit it.

Mikulas
