Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789Ab0FQVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:16:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37867 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0FQVQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:16:23 -0400
Date: Thu, 17 Jun 2010 14:14:41 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617211440.GZ24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <m1hbl1eta6.fsf@fess.ebiederm.org>
 <20100617165940.GU24749@outflux.net>
 <m1typ175ip.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1typ175ip.fsf@fess.ebiederm.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 01:45:02PM -0700, Eric W. Biederman wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> > On Thu, Jun 17, 2010 at 05:29:53AM -0700, Eric W. Biederman wrote:
> >> Kees Cook <kees.cook@canonical.com> writes:
> >> > running state of any of their processes. For example, if one application
> >> > (e.g. Pidgin) was compromised, it would be possible for an attacker to
> >> > attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
> >> > etc) to extract additional credentials and continue to expand the scope
> >> > of their attack without resorting to user-assisted phishing.
> >> 
> >> This is ineffective.  As an attacker after I gain access to a users
> >> system on ubuntu I can wait around until a package gets an update,
> >> and then run sudo and gain the power to do whatever I want.
> >
> > I doesn't stop phishing, correct.  But it does stop immediate expansion of
> > an attack using already-existing credentials.
> 
> sudo last I checked caches your password for a couple of seconds.
> So if you can probe the system to see when those couple of seconds
> are.

Sure, that's a downside of sudo, which is why privilege elevation has been
tending to move towards PolicyKit, FWIW.

> The archives of the containers list.
> https://lists.linux-foundation.org/pipermail/containers/ or just
> looking.

I'll go dig around.

>   Things like /proc/sys/ will be default stay in the same user_namespace
>   and root in other user namespaces will only get world permissions when
>   accessing files.

Excellent.  I'll move my questions about this to the containers mailing
list.

-Kees

-- 
Kees Cook
Ubuntu Security Team
