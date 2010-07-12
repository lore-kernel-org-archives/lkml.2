Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0GLGvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:51:40 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:55338 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab0GLGvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:51:39 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2010 02:51:39 EDT
Message-ID: <4C3ABA35.7020507@davidnewall.com>
Date: Mon, 12 Jul 2010 16:16:13 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <20100711131640.GA3503@thunk.org>
In-Reply-To: <20100711131640.GA3503@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o wrote:
> It is possible to do other types of release strategies, but look at
> Debian Obsolete^H^H^H^H^H^H^H^H Stable if you want to see what happens
> if you insist on waiting until all release blockers are fixed

I don't know if Ted intended to be snide, but that is how he sounded.  
And yet, his comment was a fair reflection of how core developers seem 
to feel about stability, namely that a stable kernel is obsolete and 
therefore not particularly desirable.  (I use the word "stable" in it's 
common English meaning, not the almost inexplicable Tux variation.)

I think the truth is that linux kernels are only ever stable as released 
by distributions, and then only the more conservative of them.  What 
comes direct from kernel.org, I mean those called "latest stable", are 
an exercise in dissembling.  It's stable because someone calls it 
stable, even though it crashes and has regressions?  That's not stable, 
that's just misleading.

Stable kernels *could* be stable.  Debian succeeds.  If it takes them a 
long time, that is only because the core developers fail to release 
reasonable quality kernels.  Don't sneer at them because they do the 
right thing; do the right thing yourself so that they can produce more 
timely updates.

I don't expect fair consideration of these comments; why change when 
shooting the messenger is so much more satisfying?
