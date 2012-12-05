Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2LEVsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:48:55 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42022 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2LEVsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:48:53 -0500
Date: Wed, 5 Dec 2012 22:48:51 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [YASB] Re: Linux 3.7-rc7
Message-ID: <20121205214851.GA11443@rhlx01.hs-esslingen.de>
References: <CA+55aFyetqyMa2BQu7kE=cqFdAysUh9gV=O5as5Chgg1EMCW7g@mail.gmail.com>
 <20121203193310.GA32762@rhlx01.hs-esslingen.de>
 <CA+55aFygWCxz=Mmogp8FoSr51rNct6ANw0Kw3y=u4Pu2iDK48Q@mail.gmail.com>
 <20121203194817.GA14594@rhlx01.hs-esslingen.de>
 <20121204072604.GA7467@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204072604.GA7467@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

got through all steps after all, and the ghost vanished.

Perhaps I did some silly mistake (marked that original master HEAD
as "bad" despite not actually having run that but rather some local
seemingly innocuous modifications - that will teach me for sure...).

Or perhaps it was something about the weird (to put it mildly) gcc ICEs
that I got when doing next bisection build on *some* of those kernels...
(i.e., some earlier effects from that, thus causing the problem)
A memtest run would be in order...
(fortunately I'm one generation post magnetic core memory on this "box" :-))

Just saw the -rc8 announce, thus I wanted to clarify status now,
but I'm still only 98% solid about this bisection result here.
Probably best to go straight ahead to -rc8.

Andreas Mohr
