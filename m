Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2JDRQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:16:08 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:43460 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2JDRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:16:06 -0400
Date: Thu, 4 Oct 2012 13:16:02 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Kees Cook <kees@outflux.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121004171602.GA20155@elliptictech.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004161422.GF9092@outflux.net>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-04 09:14 -0700, Kees Cook wrote:
> On Thu, Oct 04, 2012 at 12:03:54PM -0400, Nick Bowler wrote:
> > On 2012-10-04 08:49 -0700, Kees Cook wrote:
> > > On Thu, Oct 04, 2012 at 09:35:04AM -0400, Nick Bowler wrote:
[...]
> > > > The thing that bothers me most about all this is that it's basically
> > > > impossible to see why things are failing without digging through the git
> > > > tree or posting to the mailing list (or recalling earlier mailing list
> > > > discussions about the restriction, as I vaguely do now).  You just
> > > > suddenly get "permission denied" errors when all the permissions
> > > > involved look fine.  As far as I know, the owner, group and mode of
> > > > symlinks have always been completely meaningless.  Upgrade to 3.6, and
> > > > they're suddenly meaningful in extremely non-obvious ways.
> > > 
> > > FWIW, there should have been an audit message about it in dmesg.
> > 
> > There were zero messages in the kernel log.
> > 
> >   # dmesg -C
> >   # cd /tmp
> >   # mkdir testdir
> >   # ln -s testdir testlink
> >   # chown -h nobody testlink
> >   # cd testlink
> >   cd: permission denied: testlink
> >   # dmesg
> >   (no output)
> 
> Well that's sad. :( Two situations I can think of for that:
> - the kernel wasn't build with CONFIG_AUDIT

Indeed, I do not have this option enabled.  Why would I have it?  The
description says it's for SELinux, which I do not use.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

