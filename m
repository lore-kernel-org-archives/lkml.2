Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1GUSq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:46:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab1GUSq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:46:56 -0400
Date: Thu, 21 Jul 2011 20:45:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        john stultz <johnstul@us.ibm.com>, Willy Tarreau <w@1wt.eu>,
        MINOURA Makoto <minoura@valinux.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110721184524.GB381@elte.hu>
References: <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
 <1310434819.30337.21.camel@work-vm>
 <20110712041938.GO27254@1wt.eu>
 <1310690138.3367.61.camel@work-vm>
 <1310724097.2586.296.camel@twins>
 <1310752795.2945.4.camel@work-vm>
 <20110721072256.GE9216@elte.hu>
 <1311251098.29152.130.camel@twins>
 <20110721125008.GF11246@pcnci.linuxbox.cz>
 <1311252799.29152.147.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311252799.29152.147.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2011-07-21 at 14:50 +0200, Nikola Ciprich wrote:
> > thanks for the patch! I'll put this on our testing boxes...
> 
> With a patch that frobs the starting value close to overflowing I hope,
> otherwise we'll not hear from you in like 7 months ;-)
> 
> > Are You going to push this upstream so we can ask Greg to push this to
> > -stable? 
> 
> Yeah, I think we want to commit this with a -stable tag, Ingo?

yeah - and we also want a Reported-by tag and an explanation of how 
it can crash and why it matters in practice. I can then stick it into 
the urgent branch for Linus. (probably will only hit upstream in the 
merge window though.)

Thanks,

	Ingo
