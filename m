Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1C2Hav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:30:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab1C2Hau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:30:50 -0400
Date: Tue, 29 Mar 2011 09:30:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
Message-ID: <20110329073037.GK27398@elte.hu>
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
 <4D90A08D.707@zytor.com>
 <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
 <4D90A1FE.4000405@zytor.com>
 <1301324940.14261.232.camel@gandalf.stny.rr.com>
 <20110328181855.GA6146@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328181855.GA6146@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Mar 28, 2011 at 11:09:00AM -0400, Steven Rostedt wrote:
> > Geeze, I never expected such a fuss over a simple change ;)
> 
> And it's still broken ;-)
> 
> WARN_ON_SMP(x) should expand to x, not 0.

Dunno, we really do not want to *guarantee* side-effects in WARN_ON() 
constructs.

Thanks,

	Ingo
