Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1FMFFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 01:05:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61145 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1FMFFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 01:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xp9qmzUb0TcijnUS15e0X3ByZHRv06p65QttgfiqM9SgNNCWMr7qqwN6znPkTM6i46
         RJmkdD6FBQWXUz2fHMflyBl1/ITEjYReT+c2hAcXJoy4EjyMVjYk8ZB7Gf2xGn5Iw73m
         s7NHO8mUwIeYh9RK6J+3wn7/MedTcAdhcjJNQ=
Subject: Re: [PATCH] Documentation:fix the wrong file position in
 sched-arch.txt
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTiknFkJ+TE5OYBuJm8gOoi1pMzbzTA@mail.gmail.com>
References: <1307939723-2953-1-git-send-email-wanlong.gao@gmail.com>
	 <BANLkTiknFkJ+TE5OYBuJm8gOoi1pMzbzTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 13:05:17 +0800
Message-ID: <1307941517.2703.0.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2011-06-12 at 21:56 -0700, Connor Hansen wrote:
> On Sun, Jun 12, 2011 at 9:35 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> > The arch i386 had changed to x86.
> 
> $ grep -R "i386" Documentation/ | wc -l
> 155
> 
> Fix them all with:
> grep -lZR "i386" Documentation/ | xargs -0 -l sed -i -e 's/i386/x86/g'
> 
> or send ~ 100 patches
You see, but not all i386 can change to x86 in Documentation/
right?

Thanks
> 
> -Connor
> 
> >
> > Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> > ---
> >  Documentation/scheduler/sched-arch.txt |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
> > index d43dbcb..28aa107 100644
> > --- a/Documentation/scheduler/sched-arch.txt
> > +++ b/Documentation/scheduler/sched-arch.txt
> > @@ -66,7 +66,7 @@ Your cpu_idle routines need to obey the following rules:
> >            barrier issued (followed by a test of need_resched with
> >            interrupts disabled, as explained in 3).
> >
> > -arch/i386/kernel/process.c has examples of both polling and
> > +arch/x86/kernel/process.c has examples of both polling and
> >  sleeping idle functions.
> >
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


