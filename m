Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030625Ab2CSKvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2CSKvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:51:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1331746607.5104.93.camel@jerome.southpole.se>
References: <1331746607.5104.93.camel@jerome.southpole.se> <1331738610.5104.84.camel@jerome.southpole.se> <1331736182.5104.74.camel@jerome.southpole.se> <CACM3HyHaFqVBaALMNB9dTE+7JrT1qD0jrYtV2PzwTskv8sW4Hg@mail.gmail.com> <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233858.13888.34822.stgit@warthog.procyon.org.uk> <201203130900.41993.arnd@arndb.de> <11556.1331723400@redhat.com> <18016.1331738258@redhat.com> <21309.1331744879@redhat.com> 
To: Jonas Bonn <jonas@southpole.se>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        hpa@zytor.com, torvalds@linux-foundation.org
Subject: Re: [ORLinux] [PATCH 17/35] Make asm-generic/cmpxchg.h #include asm-generic/cmpxchg-local.h [ver #2]
Date: Mon, 19 Mar 2012 10:51:27 +0000
Message-ID: <4913.1332154287@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Bonn <jonas@southpole.se> wrote:

> or32-linux is supported in the toolchain from openrisc.net.  Likewise
> or32-elf... follow the instructions (the easy ones should work) on the
> link I sent you -- the submodules in the "toolchain" repo are from the
> openrisc git repo and contain everything that is needed.

I would like to include support as part of my mass-build cross-compiler RPMs.
Do you have patches anywhere against upstream binutils and gcc that I might
apply to mine?

David
