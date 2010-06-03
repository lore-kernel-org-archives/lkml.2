Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0FCEnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:43:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54966 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0FCEnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:43:21 -0400
Date: Wed, 2 Jun 2010 21:42:31 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v4] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100603044231.GB4971@outflux.net>
References: <20100602222302.GC6554@outflux.net>
 <AANLkTinnzPBlbB6q2v9Bfg55Rum809ko-K0ecWQJwWbB@mail.gmail.com>
 <20100603011840.GA4971@outflux.net>
 <AANLkTikWCDptyzts8wC2Rf7SMr5HvrHdVd5BniNnbHhb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikWCDptyzts8wC2Rf7SMr5HvrHdVd5BniNnbHhb@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:42:21AM +0800, Dave Young wrote:
> On Thu, Jun 3, 2010 at 9:18 AM, Kees Cook <kees.cook@canonical.com> wrote:
> > On Thu, Jun 03, 2010 at 08:51:28AM +0800, Dave Young wrote:
> >> On Thu, Jun 3, 2010 at 6:23 AM, Kees Cook <kees.cook@canonical.com> wrote:
> >> > v2:
> >> >  - moved sysctl extern into security.h.
> >>
> >> Not in v4?
> >>
> >> > v3:
> >> >  - move into VFS core.
> >> >  - rename sysctl, invert logic.
> >
> > Right, as part of the "move out of security/" the sysctl moved to live in
> > fs/namei.c (and therefore needed an extern in kernel/sysctl.c).
> 
> Then linux/fs.h is the place to go
> sysctl_nr_open_min and sysctl_nr_open_max can go there as well.

Okay, I wasn't sure if that was right or not.  I'll do that for v6, and
send the sysctl_nr_open_* in a separate patch.

Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
