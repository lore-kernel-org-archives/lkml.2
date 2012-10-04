Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946576Ab2JDVbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:31:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33781 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946512Ab2JDVbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:31:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 4 Oct 2012 23:30:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Kees Cook <kees@outflux.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121004233038.2a4c1c10@stein>
In-Reply-To: <20121004171602.GA20155@elliptictech.com>
References: <20121003194614.GA2893@elliptictech.com>
	<20121003200515.GZ9092@outflux.net>
	<CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
	<20121003204141.GB6026@thunk.org>
	<20121003204919.GA9092@outflux.net>
	<CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
	<20121004133504.GA5599@elliptictech.com>
	<20121004154919.GE9092@outflux.net>
	<20121004160354.GA19347@elliptictech.com>
	<20121004161422.GF9092@outflux.net>
	<20121004171602.GA20155@elliptictech.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 04 Nick Bowler wrote:
> On 2012-10-04 09:14 -0700, Kees Cook wrote:
> > On Thu, Oct 04, 2012 at 12:03:54PM -0400, Nick Bowler wrote:
> > > On 2012-10-04 08:49 -0700, Kees Cook wrote:
> > > > FWIW, there should have been an audit message about it in dmesg.
> > > 
> > > There were zero messages in the kernel log.
> > > 
> > >   # dmesg -C
> > >   # cd /tmp
> > >   # mkdir testdir
> > >   # ln -s testdir testlink
> > >   # chown -h nobody testlink
> > >   # cd testlink
> > >   cd: permission denied: testlink
> > >   # dmesg
> > >   (no output)
> > 
> > Well that's sad. :( Two situations I can think of for that:
> > - the kernel wasn't build with CONFIG_AUDIT
> 
> Indeed, I do not have this option enabled.  Why would I have it?  The
> description says it's for SELinux, which I do not use.

It says it is /among else/ for SELinux.  Another user appears to be
ConsoleKit, which wants CONFIG_AUDITSYSCALL, which depends on CONFIG_AUDIT.
-- 
Stefan Richter
-=====-===-- =-=- --=--
http://arcgraph.de/sr/
