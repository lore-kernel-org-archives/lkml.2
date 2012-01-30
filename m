Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2A3NmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:42:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab2A3NmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:42:24 -0500
Date: Mon, 30 Jan 2012 14:42:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Michael D Labriola <michael.d.labriola@gmail.com>
Subject: Re: [PATCH] x86, reboot: reduce to a single DMI table for reboot
 quirks
Message-ID: <20120130134205.GA3351@elte.hu>
References: <87ty3eb9c9.fsf@gmail.com>
 <20120130095537.GA8924@elte.hu>
 <OFE2532E18.A9BD6FEB-ON85257995.004A4456-85257995.004ABE7E@gdeb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE2532E18.A9BD6FEB-ON85257995.004A4456-85257995.004ABE7E@gdeb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael D Labriola <mlabriol@gdeb.com> wrote:

> > I realize that you only move code here - but it's worth 
> > cleaning it up a bit when touching it.
> 
> You are requesting that I clean up only the comments that 
> appear in the diff, correct?  I'll do that as well.

Yeah, and whatever other cleanliness detail you notice: when we 
touch some code it is the best opportunity to improve it.

I'd also suggest for ou to do it as two patches: first keep your 
existing patch then do a second one on top of it cleaning up any 
details, and send me both.

Thanks,

	Ingo
