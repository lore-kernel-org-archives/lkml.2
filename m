Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1GWP4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 11:56:30 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:35060 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1GWP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 11:56:26 -0400
Date: Sat, 23 Jul 2011 18:55:48 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Keith Packard <keithp@keithp.com>
cc: Kirill Smelkov <kirr@mns.spb.ru>, Chris Wilson <chris@chris-wilson.co.uk>,
        Luke-Jr <luke@dashjr.org>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
In-Reply-To: <yunsjpyrqf7.fsf@aiko.keithp.com>
Message-ID: <alpine.DEB.2.00.1107231847520.4843@tiger>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru>
 <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru> <yun7h7atcty.fsf@aiko.keithp.com> <20110722202336.GA14375@tugrik.mns.mnsspb.ru>
 <yunsjpyrqf7.fsf@aiko.keithp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Fri, 22 Jul 2011, Keith Packard wrote:
>> Sorry, to me it all looked like "UMS is being ignored forever".
>
> You're right, of course -- UMS is a huge wart on the kernel driver at
> this point, keeping it working while also adding new functionality
> continues to cause challenges. We tend to expect that most people will
> run reasonably contemporaneous kernel and user space code, and so three
> years after the switch, it continues to surprise us when someone
> actually tries UMS.

I know I sound like a broken record but I really wish you i915 devs were 
little more eager to revert broken patches early rather than late. I mean, 
this particular breakage was already bisected but nobody said or 
did anything - and it's not like it's the first time either!

I suppose I need to bribe Linus somehow to be more strict with you folks.

 			Pekka
