Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0DAMwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:52:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab0DAMw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:52:28 -0400
Date: Thu, 1 Apr 2010 14:52:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100401125210.GA2445@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
 <4BB2EB1B.8090303@zytor.com>
 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <20100331185916.GA12306@elte.hu>
 <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
 <4BB3DC4E.7030504@zytor.com>
 <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org>
 <4BB3DF46.8080008@zytor.com>
 <alpine.LRH.2.00.1004011200020.365@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1004011200020.365@tundra.namei.org>
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


* James Morris <jmorris@namei.org> wrote:

> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
> 
> > On 03/31/2010 04:43 PM, James Morris wrote:
> > >>
> > >> Upgraded how?  The problem no longer happens?
> > > 
> > > Upgraded to the latest rawhide userland -- I have not since tested with 
> > > bootmem off.  I'll try and do so again when I get a chance.
> > > 
> > 
> > That would be great.  The sooner the better, obviously.
> 
> I'm not seeing any problems now, with current Linus and rawhide.  I'll leave 
> bootmem off and see if anything comes up again.

(a current bootlog would still be nice)

Dave, can you reproduce any of these problems with Linus's latest?

	Ingo
