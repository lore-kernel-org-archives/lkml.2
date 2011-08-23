Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1HWIY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:24:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:43449 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab1HWIYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:24:25 -0400
Date: Tue, 23 Aug 2011 18:24:14 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] CRED: fix build error due to 'tgcred' undeclared
In-Reply-To: <25044.1314084987@redhat.com>
Message-ID: <alpine.LRH.2.00.1108231823260.27020@tundra.namei.org>
References: <1314084231.5033.1.camel@phoenix> <25044.1314084987@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, David Howells wrote:

> Axel Lin <axel.lin@gmail.com> wrote:
> 
> > This patch adds CONFIG_KEYS guard for tgcred to fix below build error
> > if CONFIG_KEYS is not configured.
> > 
> >   CC      kernel/cred.o
> > kernel/cred.c: In function 'prepare_kernel_cred':
> > kernel/cred.c:657: error: 'tgcred' undeclared (first use in this function)
> > kernel/cred.c:657: error: (Each undeclared identifier is reported only once
> > kernel/cred.c:657: error: for each function it appears in.)
> > make[1]: *** [kernel/cred.o] Error 1
> > make: *** [kernel] Error 2
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> James: do you want me to reissue my patches?
> 

Nope, I needed a differential patch as I'd already pushed that branch out.

Thanks.


-- 
James Morris
<jmorris@namei.org>
