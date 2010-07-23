Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867Ab0GWUGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:06:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758060Ab0GWUGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:06:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tim.gardner@canonical.com, Eric Anholt <eric@anholt.net>,
        Kees Cook <kees@outflux.net>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
Date: Fri, 23 Jul 2010 22:04:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.9fB.v3XSMB@chimera> <4C4994FB.9090205@mail.tpi.com>
In-Reply-To: <4C4994FB.9090205@mail.tpi.com>
MIME-Version: 1.0
Message-Id: <201007232204.30319.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Tim Gardner wrote:
> On 07/23/2010 01:47 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
> > Subject		: [Q35 bisected] hang at init of i915 driver
> > Submitter	: Kees Cook<kees@outflux.net>
> > Date		: 2010-06-25 18:20 (29 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
> > Handled-By	: Tim Gardner<tim.gardner@canonical.com>
> > Patch		: https://patchwork.kernel.org/patch/111130/
> >
> >
> 
> There is a patch attached to the BZ report that has been ack'd by a 
> couple of testers as well as by the original committer. I've been told 
> that it should go through Eric Anholt instead of Dave Arlie, but Eric 
> has yet to respond.

Eric?

> Acked-by and Tested-by included in this thread: 
> http://lkml.org/lkml/2010/7/21/278

Thanks for the update.

Rafael
