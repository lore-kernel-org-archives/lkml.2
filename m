Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2DFAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:16:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab2DFAQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:16:26 -0400
Date: Thu, 5 Apr 2012 17:16:24 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: Lucia Rosculete <luciarosculete@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] semaphore: fix comment
In-Reply-To: <CAEnQRZAitvn9R+fzgFSjvak2yv8dwnRepShR7Ws71uBqeJHs8A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204051716140.9041@pobox.suse.cz>
References: <1330784327-7172-1-git-send-email-luciarosculete@gmail.com> <CAEnQRZAitvn9R+fzgFSjvak2yv8dwnRepShR7Ws71uBqeJHs8A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Daniel Baluta wrote:

> On Sat, Mar 3, 2012 at 4:18 PM, Lucia Rosculete
> <luciarosculete@gmail.com> wrote:
> >         Replace "mutex" with "semaphore" in down_trylock comment
> >
> > Signed-off-by: Lucia Rosculete <luciarosculete@gmail.com>
> > ---
> >  kernel/semaphore.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/semaphore.c b/kernel/semaphore.c
> > index 60636a4..4567fc0 100644
> > --- a/kernel/semaphore.c
> > +++ b/kernel/semaphore.c
> > @@ -118,7 +118,7 @@ EXPORT_SYMBOL(down_killable);
> >  * down_trylock - try to acquire the semaphore, without waiting
> >  * @sem: the semaphore to be acquired
> >  *
> > - * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
> > + * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
> >  * been acquired successfully or 1 if it it cannot be acquired.
> >  *
> >  * NOTE: This return value is inverted from both spin_trylock and
> 
> Hello Jiri,
> 
> Can you have a look?

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
