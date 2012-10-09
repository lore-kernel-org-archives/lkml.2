Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2JISwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:52:44 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:8167 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2JISwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:52:41 -0400
Date: Tue, 9 Oct 2012 14:51:54 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kees Cook <kees@outflux.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121009185153.GA13342@elliptictech.com>
References: <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
 <20121003204141.GB6026@thunk.org>
 <20121003204919.GA9092@outflux.net>
 <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
 <20121004133504.GA5599@elliptictech.com>
 <20121004154919.GE9092@outflux.net>
 <20121004160354.GA19347@elliptictech.com>
 <20121004161422.GF9092@outflux.net>
 <20121004171602.GA20155@elliptictech.com>
 <20121004233038.2a4c1c10@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004233038.2a4c1c10@stein>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-04 23:30 +0200, Stefan Richter wrote:
> On Oct 04 Nick Bowler wrote:
> > On 2012-10-04 09:14 -0700, Kees Cook wrote:
> > > On Thu, Oct 04, 2012 at 12:03:54PM -0400, Nick Bowler wrote:
> > > > On 2012-10-04 08:49 -0700, Kees Cook wrote:
> > > > > FWIW, there should have been an audit message about it in dmesg.
[...]
> > > >   # dmesg
> > > >   (no output)
> > > 
> > > Well that's sad. :( Two situations I can think of for that:
> > > - the kernel wasn't build with CONFIG_AUDIT
> > 
> > Indeed, I do not have this option enabled.  Why would I have it?  The
> > description says it's for SELinux, which I do not use.
> 
> It says it is /among else/ for SELinux.  Another user appears to be
> ConsoleKit, which wants CONFIG_AUDITSYSCALL, which depends on CONFIG_AUDIT.

Indeed, you are correct that the help text does imply that there are
(potentially) other users besides SElinux, although it does not say what
they are.  Regardless, the point is that I have no idea why I would have
this optional feature enabled, as I still don't even know what it does
because the help text doesn't actually say.  I even found a website,
http://people.redhat.com/sgrubb/audit/, which seems to be related to
this feature but even here I cannot find one sentence explaining what
the feature is.

Well, from this thread I now know that this feature enables, at least
in some cases, printk messages when your previously-working scripts are
broken by a kernel update.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

