Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab0D3SKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:10:14 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:40957 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933726Ab0D3SJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:09:42 -0400
Date: Fri, 30 Apr 2010 09:55:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
Message-ID: <20100430075510.GA21105@elte.hu>
References: <4BD80037.9060704@kernel.org>
 <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 28 Apr 2010, Tejun Heo wrote:
> 
> > The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
> > causes annoying problems with some editors and tools.  Use (C)
> > instead.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Paul Mackerras <paulus@au1.ibm.com>
> > ---
> > I'm not really sure this would survive transport over mail in
> > appliable form, attaching the patch too just in case.
> 
> It didn't survive :) But it was easy enough to fix by hand. Applied, 
> thanks Tejun.

NAK.

A similar patch was sent a few weeks ago, it was objected to and rejected - 
the copyright character was used for legal reasons.

Jiri, in the future please dont apply 'trivial' patches that involve 
subsystems that i co-maintain and which is not acked by any of the subsystem 
maintainers.

Thanks,

	Ingo
