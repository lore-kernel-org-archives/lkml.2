Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2CSLdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:33:45 -0400
Received: from mail.southpole.se ([193.12.106.18]:40194 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2CSLdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:33:43 -0400
Message-ID: <1332156798.2068.11.camel@jerome.southpole.se>
Subject: Re: [ORLinux] [PATCH 17/35] Make asm-generic/cmpxchg.h #include
 asm-generic/cmpxchg-local.h [ver #2]
From: Jonas Bonn <jonas@southpole.se>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org
Date: Mon, 19 Mar 2012 12:33:18 +0100
In-Reply-To: <4913.1332154287@redhat.com>
References: <1331746607.5104.93.camel@jerome.southpole.se>
	 <1331738610.5104.84.camel@jerome.southpole.se>
	 <1331736182.5104.74.camel@jerome.southpole.se>
	 <CACM3HyHaFqVBaALMNB9dTE+7JrT1qD0jrYtV2PzwTskv8sW4Hg@mail.gmail.com>
	 <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	 <20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
	 <201203130900.41993.arnd@arndb.de> <11556.1331723400@redhat.com>
	 <18016.1331738258@redhat.com> <21309.1331744879@redhat.com>
	  <4913.1332154287@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 56801-00431
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2012-03-19 at 10:51 +0000, David Howells wrote:
> Jonas Bonn <jonas@southpole.se> wrote:
> 
> > or32-linux is supported in the toolchain from openrisc.net.  Likewise
> > or32-elf... follow the instructions (the easy ones should work) on the
> > link I sent you -- the submodules in the "toolchain" repo are from the
> > openrisc git repo and contain everything that is needed.
> 
> I would like to include support as part of my mass-build cross-compiler RPMs.
> Do you have patches anywhere against upstream binutils and gcc that I might
> apply to mine?

I could certainly put together such patches for you.  What upstream
versions are you using?

/Jonas

