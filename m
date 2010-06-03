Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0FCSmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:42:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51082 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0FCSmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:42:06 -0400
Date: Thu, 3 Jun 2010 11:40:54 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Young <hidave.darkstar@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100603184054.GA4714@outflux.net>
References: <20100603080158.GE4971@outflux.net>
 <20100603104149.78402075@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603104149.78402075@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:41:49AM +0100, Alan Cox wrote:
> > Past objections and rebuttals could be summarized as:
> 
> You've forgotten to update this with the list of the objections from your
> last few days postings.

I didn't think the recent discussions added anything thematically new.
"It changes how symlinks work" is a variation on "breaks POSIX", and
"should be done with per-user /tmp" is a variabtion on "userspace should
fix it".  I can certainly reword the commit log, though.

> You've forgotten to update it as suggested so its a security policy

It is a sysctl with a CONFIG, which is what Eric Paris was asking for.
I apologize if I missed something, but if there are further improvements
desired, I'm happy to add patches.

> Do you plan to post this daily until we get fed up of seeing it ?

I plan on getting this functionality into the kernel.  As such, whenever
I've been directed to improve it before it will be accepted, I will send
an updated version.  Having the lifecycle of this patch blocking on me
seems counter-productive and slightly rude.

At this point, I believe I've addressed the specific concerns that Al Viro,
Eric Paris, and a few others pointed out.  What else needs fixing?

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
