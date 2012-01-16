Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2APJzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:55:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2APJzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:55:44 -0500
Date: Mon, 16 Jan 2012 10:55:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Fleming <matt@console-pimps.org>
Cc: Keith Packard <keithp@keithp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
Message-ID: <20120116095529.GA838@elte.hu>
References: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
 <867h22jwj1.fsf@sumi.keithp.com>
 <4EE575E3.7090206@zytor.com>
 <8639cqjvyn.fsf@sumi.keithp.com>
 <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
 <86sjkpiw8i.fsf@sumi.keithp.com>
 <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com>
 <1326705757.3629.18.camel@mfleming-mobl1.ger.corp.intel.com>
 <20120116093133.GB15333@elte.hu>
 <1326707367.3629.26.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326707367.3629.26.camel@mfleming-mobl1.ger.corp.intel.com>
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


* Matt Fleming <matt@console-pimps.org> wrote:

> > Failing that i guess we'll have to do the revert, and re-try 
> > the original commit with your fix merged into it.
> 
> The revert is already in Linus' tree as e1ad783b12ec "Revert 
> "x86, efi: Calling __pa() with an ioremap()ed address is 
> invalid", so at least we've got some time to get this patch 
> right.

Yeah, indeed - the hollidays made me forget everything and back 
then tip-bot notification was not restored yet so today i 
assumed the issue is still open ;-)

Does your new patch apply cleanly on top of the revert? If not 
then please send an updated one, so that we can investigate its 
effects.

Thanks,

	Ingo
