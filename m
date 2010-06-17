Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243Ab0FQW0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:26:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54532 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab0FQW0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:26:18 -0400
Date: Thu, 17 Jun 2010 15:25:04 -0700
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
Message-ID: <20100617222504.GD24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100617000120.13071be8@lxorguk.ukuu.org.uk>
 <20100616232230.GP24749@outflux.net>
 <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
 <20100617170453.GV24749@outflux.net>
 <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
 <20100617140630.c6ced27a.rdunlap@xenotime.net>
 <20100617211616.GA24749@outflux.net>
 <20100617231859.04fcdbde@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617231859.04fcdbde@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 11:18:59PM +0100, Alan Cox wrote:
> > And for them, it certainly seems like a good idea to be able to turn off
> > PTRACE without having to fiddle with an LSM.
> 
> But that *is* an LSM, its a security policy.
> 
> You don't seem to get it - even the default kernel security is a
> security policy (security/commoncap.c etc)

I do get it.  I also get that every LSM calls out to commoncap, making
it effectively stacked with the primary LSM -- the only LSM that gets
stacked.  In fact, this is how I even started implementing these features:
as patches to commoncap, but James preferred it to be in core since they
are of general utility.  But core people want the changes in security/
instead.

I don't mind putting them in commoncap at all.  I would just like people
to agree on what they disagree about.  :)

-Kees

-- 
Kees Cook
Ubuntu Security Team
