Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0KRHcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:32:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0KRHcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:32:16 -0500
Date: Thu, 18 Nov 2010 08:31:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Marcus Meissner <meissner@suse.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, akpm@osdl.org,
        hpa@zytor.com, w@1wt.eu, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101118073126.GB32621@elte.hu>
References: <20101116104600.GA24015@suse.de>
 <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Putting aside the kallsyms patch (which is a tiny part of a fuller solution), i'd 
like to reply to this particular point:

* Kyle Moffett <kyle@moffetthome.net> wrote:

>   (2) Most of the arguments about introducing "uncertainty" into the
> hacking process are specious as well. [...]

It is only specious if you ignore the arguments i made in the previous
discussion. One argument i made was:

  Future trends are also clear: eventually, as more and more of our lives
  are lived on the network, home boxes are becoming more and more valuable.
  So i think concentrating on the psychology of the skilled attacker would
  not be unwise. YMMV.

>                                  [...]  If a kernel bug is truly a
> "workable" vulnerability then 99%+ of the attempts to exploit it would
> be completely automated virii and computer worms that don't really
> care what happens if they fail to compromise the system.  Take a look
> at the vast collection of sample code we have in the form of Windows
> virii/trojans/worms/malware/etc; care to guess what portion of those
> programs authors would shed a tear if their exploit horribly crashed
> or generated vast amounts of audit spam for 70% of the computers it
> executed on?

( You'd be a fool to think that even windows malware authors do not care
  whether they crash the target box. You do not get a botnet of 10 million PCs if
  you crash 99% of them. There is an analogous concept for this in biology: if a
  biological virus is _too_ deadly, it will never become a pandemic - because it has
  no time/chance to spread, they are 'detected' and 'defended against'. Virii like
  Ebola never spread widely, because they kill all their hosts. )

More importantly, look forward and take a look at the really intelligent attacks, 
which are used against high-value targets with good defenses. Those real examples 
give us a glimpse into future techniques, even if you do not accept my arguments 
that come to a similar conclusion. Those attacks are all about avoiding detection.

Thanks,

	Ingo
