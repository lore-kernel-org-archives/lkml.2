Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1KFVUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:20:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1KFVUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:20:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
Date: Sun, 6 Nov 2011 22:23:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111103223113.GR4417@google.com> <201111062210.11759.rjw@sisk.pl> <CAOS58YOAKK_tVfwsfnEzNZpH1e=4OA52v9yE+ymGk7LfQB4+OA@mail.gmail.com>
In-Reply-To: <CAOS58YOAKK_tVfwsfnEzNZpH1e=4OA52v9yE+ymGk7LfQB4+OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111062223.10517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 06, 2011, Tejun Heo wrote:
> Hello,
> 
> On Sun, Nov 6, 2011 at 1:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Do you mean something like this is needed on top of linux-pm/pm-freezer:
> >
> > ---
> >  kernel/freezer.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux-pm/kernel/freezer.c
> > ===================================================================
> > --- linux-pm.orig/kernel/freezer.c
> > +++ linux-pm/kernel/freezer.c
> > @@ -90,7 +90,7 @@ static void fake_signal_wake_up(struct t
> >        unsigned long flags;
> >
> >        if (lock_task_sighand(p, &flags)) {
> > -               signal_wake_up(p, 1);
> > +               signal_wake_up(p, 0);
> 
> Yeap, that was the only discrepancy I could find.

OK, I'll apply this on top of the merge commit.

Thanks,
Rafael
