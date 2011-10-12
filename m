Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab1JLIrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:47:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1JLIrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:47:07 -0400
Date: Wed, 12 Oct 2011 10:45:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision v5
Message-ID: <20111012084523.GB27853@elte.hu>
References: <1317251993-5030-1-git-send-email-andi@firstfloor.org>
 <20111010070044.GM32173@elte.hu>
 <20111011152050.GE14482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011152050.GE14482@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Oct 10, 2011 at 09:00:44AM +0200, Ingo Molnar wrote:
> > 
> > Andi,
> > 
> > If you want me to apply these patches then they need to be reviewed 
> > and signed off by someone else who i trust and who i'm taking patches 
> > from.
> 
> Ingo,
> 
> There's noone else to sign off because noone else is writing the 
> patches.

The typical way of how such maintainer requests are solved is that 
you'll have to find someone who is willing and able to work with you 
on this topic, and who is willing to forward your patches to me or to 
the other x86 maintainers (or any of the submaintainers we pull 
from). It's not hard, we get and accept a lot of indirect patches.

Arguably i've already invested more time into this than i should 
have, this direct approach clearly does not work and i cannot trust 
you.

Thanks,

	Ingo
