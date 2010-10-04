Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0JDXn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:43:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab0JDXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:43:56 -0400
Date: Mon, 4 Oct 2010 16:43:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20101004164325.e8df693f.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTikapE3RaVVFS3yBSGmCkMGUvfZECJq5eOmayWhZ@mail.gmail.com>
	<4CA4D61C.2010909@gmail.com>
	<4CA4E76E.1050602@gmail.com>
	<20101004161600.8cdf4e0c.akpm@linux-foundation.org>
	<AANLkTimmQmQU4fE9ku_wc8x_dPEfnjgOHWSM18O0=coa@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 01:33:25 +0200
Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:

> 2010/10/5 Andrew Morton <akpm@linux-foundation.org>:
> > Removal of duplicated includes is a somewhat dangerous thing. __If
> > someone else says "hey, there's a duplicated include" and then fixes
> > it, and if this patch removes the other include then whoops, we broke
> > the build. __This has happened before.
> 
> Yeah, right.
> 
> >
> > So I'd ask that you redo and resend this patch shortly after 2.6.36 is
> > released please, so I can get it into mainline quickly thus minimising
> > the opportunity for such breakage.
> 
> Ok. Do you want patch against 2.6.36 mainline, -next or -mmotm?

Mainline is OK, thanks.


