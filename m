Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab0FRR7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:59:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49070 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab0FRR7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:59:19 -0400
Date: Fri, 18 Jun 2010 10:58:29 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
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
Message-ID: <20100618175829.GI24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100617000120.13071be8@lxorguk.ukuu.org.uk>
 <20100616232230.GP24749@outflux.net>
 <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
 <20100617170453.GV24749@outflux.net>
 <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
 <20100617140630.c6ced27a.rdunlap@xenotime.net>
 <20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
 <20100617215105.GB24749@outflux.net>
 <20100617233054.330256cf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617233054.330256cf@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 17, 2010 at 11:30:54PM +0100, Alan Cox wrote:
> - You can give up now.

Failure is always an option!  :)  Nah, I was never deluded into thinking
these patches were going to be universally-loved and easy to upstream.
I posted them because I want them in, and I'm going to stick with it.

> - You can put it together as a security module - which will make people
>   happy and get your stuff upstream. After that you can have a meaningful
>   discussion about stacking, although I think you'll find that stacking
>   is really really hard because you get conflicting behaviour between
>   security modules and ignoring those conflicts ends up violating at least
>   one of the security models leaving you worse not better off.
> 
> Your path to making any of the stuff you want happen is via the security
> layer and the LSM hooks. Even if you want them stackable and usable with
> other modules your starting point is still a security module.

Sounds like this really is the only path, with the idea of finding a
chaining solution later.  Without chaining, it's only useful for people
that aren't using a full MAC.

-Kees

-- 
Kees Cook
Ubuntu Security Team
