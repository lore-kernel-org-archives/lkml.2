Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782Ab0FQVPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:15:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44313 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759930Ab0FQVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:15:39 -0400
Date: Thu, 17 Jun 2010 22:18:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617140630.c6ced27a.rdunlap@xenotime.net>
References: <20100616221833.GM24749@outflux.net>
	<20100617000120.13071be8@lxorguk.ukuu.org.uk>
	<20100616232230.GP24749@outflux.net>
	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
	<20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
	<20100617140630.c6ced27a.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thats a nonsensical configuration so we don't care. If you are using
> > SELinux you just do it via SELinux. If you are doing it via
> > UbuntuHasToBeDifferent then you do it via that.
> 
> 
> Well, surely there are people who use something other than Ubuntu
> and also care about not using SELinux... eh?

Then they can load UbuntuSecurity and use that, just enabling the
features they want.

I'm not against the Ubuntu stuff getting beaten into a security module
and put where it belongs. Far from it - I just want to see it put where
it belongs, which is not junk randomly spewed over the tree. Doubly so
when they do it wrong *because* they are not using the security hooks.

It seems pretty easy to me. Kees needs to package up the grsecurity
features that Ubuntu thinks are valuable into security/something/... with
a set of sysfs entries to turn on/off the various features. Ubuntu is
happy, people who want a simple set of sysfs feature controls for
security are happy and nobody else will even notice.

It'll appeal to some people because it looks easy to work and it won't
upset anyone else because its all nicely filed away where it belongs.

We don't put MSDOS fs hacks randomly all over the VFS[1], please don't try
and put security hacks into random bits of kernel code.

Alan
[1] Maybe we should be scarier, like Al ;)
