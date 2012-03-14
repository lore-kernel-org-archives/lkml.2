Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114Ab2CNRIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab2CNRIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:08:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1331738610.5104.84.camel@jerome.southpole.se>
References: <1331738610.5104.84.camel@jerome.southpole.se> <1331736182.5104.74.camel@jerome.southpole.se> <CACM3HyHaFqVBaALMNB9dTE+7JrT1qD0jrYtV2PzwTskv8sW4Hg@mail.gmail.com> <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233858.13888.34822.stgit@warthog.procyon.org.uk> <201203130900.41993.arnd@arndb.de> <11556.1331723400@redhat.com> <18016.1331738258@redhat.com> 
To: Jonas Bonn <jonas@southpole.se>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        hpa@zytor.com, torvalds@linux-foundation.org
Subject: Re: [ORLinux] [PATCH 17/35] Make asm-generic/cmpxchg.h #include asm-generic/cmpxchg-local.h [ver #2]
Date: Wed, 14 Mar 2012 17:07:59 +0000
Message-ID: <21309.1331744879@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn <jonas@southpole.se> wrote:

> > > The error I get while building (if asm/system.h is included) is a
> > > circular dependency that I don't see that I can easily resolve:
> > 
> > How do I get an openrisc toolchain?
> 
> http://openrisc.net/toolchain-build.html
> 
> What distro are you on?  I might be able to send you a binary version if
> you prefer...

I'd like to add it to my spec file to build the complete clutch of binutils
and gcc RPMs for Fedora.

I originally tried --target=openrisc-elf, but whilst that is supported by
binutils, it doesn't seem to be supported by gcc.

According to your URL above, I should be using --target=or32-linux, but
binutils claims not to support that:

	*** ld does not support target or32-unknown-linux-gnu

Also neither or32-linux-elf nor or32-unknown-linux-elf work.

David
