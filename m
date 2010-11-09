Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0KIUut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:50:49 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38002 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab0KIUus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:50:48 -0500
Date: Tue, 9 Nov 2010 12:50:08 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
Message-ID: <20101109205008.GU5876@outflux.net>
References: <20101025235804.GA11760@outflux.net>
 <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, Nov 09, 2010 at 10:43:07PM +0200, Pekka Enberg wrote:
> On Tue, Oct 26, 2010 at 2:58 AM, Kees Cook <kees.cook@canonical.com> wrote:
> > CVE-2010-4072
> >
> > The old shm interface will leak a few bytes of stack contents. Explicitly
> > clear structure using memset instead of C99-style initialization in case
> > there are ever holes in the packing.
> >
> > Cc: stable <stable@kernel.org>
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> 
> This looks like a genuine bug fix but I don't see this patch in
> mainline. Why is that?

No one has committed it. I don't know why; I've sent it a few times now.

-Kees

-- 
Kees Cook
Ubuntu Security Team
