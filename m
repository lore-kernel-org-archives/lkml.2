Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab2BQLVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:21:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2BQLVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:21:38 -0500
Date: Fri, 17 Feb 2012 12:21:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
Message-ID: <20120217112117.GB14789@elte.hu>
References: <86sjkpiw8i.fsf@sumi.keithp.com>
 <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com>
 <1326705757.3629.18.camel@mfleming-mobl1.ger.corp.intel.com>
 <20120116093133.GB15333@elte.hu>
 <1326707367.3629.26.camel@mfleming-mobl1.ger.corp.intel.com>
 <20120116095529.GA838@elte.hu>
 <1326708966.3629.31.camel@mfleming-mobl1.ger.corp.intel.com>
 <1328705209.3718.1.camel@mfleming-mobl1.ger.corp.intel.com>
 <86d39pfdqd.fsf@sumi.keithp.com>
 <1329307981.3675.120.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329307981.3675.120.camel@mfleming-mobl1.ger.corp.intel.com>
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

> On Wed, 2012-02-08 at 09:15 -0800, Keith Packard wrote:
> > <#part sign=pgpmime>
> > On Wed, 08 Feb 2012 12:46:49 +0000, Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > > Ping? Keith, have you had chance to test this patch yet?
> > 
> > No, I haven't had a chance to try the patch, and I'm leaving 
> > on vacation tomorrow until March 1...
> 
> Hmm... I haven't been able to find anybody else willing to 
> test this patch either.
> 
> Ingo, got any opinions on how to handle this?

Please send the latest and I'll apply it. If we don't get 
voluntary testers then involuntary ones will have to do :-/

Thanks,

	Ingo
