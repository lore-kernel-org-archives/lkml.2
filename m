Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0JTXPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:15:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937Ab0JTXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:15:49 -0400
Date: Wed, 20 Oct 2010 16:15:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removal of duplicate includes from many files
Message-Id: <20101020161547.0c9d95cc.akpm@linux-foundation.org>
In-Reply-To: <4CBF6602.3070801@gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
	<4CA4D61C.2010909@gmail.com>
	<4CA4E76E.1050602@gmail.com>
	<20101004161600.8cdf4e0c.akpm@linux-foundation.org>
	<AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
	<4CBF6602.3070801@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 23:58:26 +0200
"N.P.S." <napohybelskurwysynom2010@gmail.com> wrote:

> W dniu 2010-10-05 01:33, Zimny Lech pisze:
> > 2010/10/5 Andrew Morton<akpm@linux-foundation.org>:
> >> Removal of duplicated includes is a somewhat dangerous thing.  If
> >> someone else says "hey, there's a duplicated include" and then fixes
> >> it, and if this patch removes the other include then whoops, we broke
> >> the build.  This has happened before.
> > Yeah, right.
> >
> >> So I'd ask that you redo and resend this patch shortly after 2.6.36 is
> >> released please, so I can get it into mainline quickly thus minimising
> >> the opportunity for such breakage.
> >
> 
> I rebased series against 2.6.36 and I checked if something has not been 
> removed by someone else. Please pull
> git pull git://github.com/napohybelskurwysynom2010/Linux-2.6-nps.git rodi1
> 
> or apply attached patch

The patch was space-stuffed by your email client and hence did not
apply.  I fixed it up.

Many of these changes are already in linux-next.  I kept the changes
which aren't in linux-next and verified that none of those changes were
removing duplications which were already removed in linux-next.

