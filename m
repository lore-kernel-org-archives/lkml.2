Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0E1Skg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:40:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45330 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0E1Sk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:40:29 -0400
Date: Fri, 28 May 2010 11:39:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] fs: block cross-uid sticky symlinks
Message-ID: <20100528183952.GK6056@outflux.net>
References: <20100527201635.GU6056@outflux.net>
 <AANLkTil8HX2Eko4q7kZYQjoN5C9oPaMvBFZX0oSzBKP6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil8HX2Eko4q7kZYQjoN5C9oPaMvBFZX0oSzBKP6@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 28, 2010 at 02:10:37PM +0800, Dave Young wrote:
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -88,6 +88,7 @@ extern int sysctl_oom_dump_tasks;
> >  extern int max_threads;
> >  extern int core_uses_pid;
> >  extern int suid_dumpable;
> > +extern int weak_sticky_symlinks;
> 
> It will be better to put in security.h

Noted; I will move it there.

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
