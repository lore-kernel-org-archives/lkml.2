Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1EXW6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:58:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1EXW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:58:37 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
Date: Wed, 25 May 2011 01:00:07 +0200
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        "linux-mm" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        aufs-users@lists.sourceforge.net
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105250100.08708.hpj@urpla.net>
X-Provags-ID: V02:K0:++ayveSQbSleo76l7op9r8NMFsYK+g1k3RGBIwQCYvy
 buS745BiJlsY4OCMFgwZvzt1/2CbZs87ErxhEE5uhO3xK269kB
 ZU6L50qrtU8w/f+NFas5ym6c02sh9zrKDx4XAv5uYeDe9YAIpa
 LjhYneeO4TuiTGCPGKlw4GhfECFPZ23mWAK4tfm7YzRGFLZMTq
 74rcmZMRPN+6GM0lB2+s9mxtCBP3C32QRK1S4fYU2Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 May 2011, 22:33:48 Linus Torvalds wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > I really hope there's also a voice that tells you to wait until .42
> > before cutting 3.0.0! :-)
>
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.
>
> But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
> fairly nice round number.
>
> There's also the timing issue - since we no longer do version numbers
> based on features, but based on time, just saying "we're about to
> start the third decade" works as well as any other excuse.

But hey, do you really want to release a Linux 3.0 kernel without 
serious layered filesystem functionality? 

Shame on you,
Pete

PS.: Sorry for being such a pest in this regard, but filesystem layering 
is one of the most important missing bits to excel out of the box in
 * live distros 
 * diskless computing
 * flash based systems
Even the linux based commercial PBX solution (mobydick), I bought, ships 
with it.
PPS.: Bad timing, I know, but I'm glad, that Al is back to life again..
