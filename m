Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2CNPXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:23:37 -0400
Received: from mail.southpole.se ([193.12.106.18]:55713 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2CNPXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:23:33 -0400
Message-ID: <1331738610.5104.84.camel@jerome.southpole.se>
Subject: Re: [ORLinux] [PATCH 17/35] Make asm-generic/cmpxchg.h #include
 asm-generic/cmpxchg-local.h [ver #2]
From: Jonas Bonn <jonas@southpole.se>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org
Date: Wed, 14 Mar 2012 16:23:30 +0100
In-Reply-To: <18016.1331738258@redhat.com>
References: <1331736182.5104.74.camel@jerome.southpole.se>
	 <CACM3HyHaFqVBaALMNB9dTE+7JrT1qD0jrYtV2PzwTskv8sW4Hg@mail.gmail.com>
	 <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	 <20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
	 <201203130900.41993.arnd@arndb.de> <11556.1331723400@redhat.com>
	  <18016.1331738258@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 38610-08253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-03-14 at 15:17 +0000, David Howells wrote:
> Jonas Bonn <jonas@southpole.se> wrote:
> 
> > Am I right in thinking that OpenRISC is the only architecture the
> > depends on the changes in asm-generic?
> 
> I'm not sure.  I think c6x does too to some extent.


> > The error I get while building (if asm/system.h is included) is a
> > circular dependency that I don't see that I can easily resolve:
> 
> How do I get an openrisc toolchain?

http://openrisc.net/toolchain-build.html

What distro are you on?  I might be able to send you a binary version if
you prefer...

/Jonas

> 
> David


