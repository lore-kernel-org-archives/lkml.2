Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0CZVyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:54:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0CZVyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:54:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [Bug #15142] sysfs-related lockdep warning in __blkdev_get
Date: Fri, 26 Mar 2010 22:57:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>,
       NeilBrown <neilb@suse.de>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.J8F.wQopLB@chimera> <2375c9f91003252311j24d0a13ekbe1484f0d789e392@mail.gmail.com>
In-Reply-To: <2375c9f91003252311j24d0a13ekbe1484f0d789e392@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003262257.30970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 March 2010, Américo Wang wrote:
> On Mon, Mar 22, 2010 at 4:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.32 and 2.6.33.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15142
> > Subject         : sysfs-related lockdep warning in __blkdev_get
> > Submitter       : Matti Aarnio <matti.aarnio--kernel-bugzilla@zmailer.org>
> > Date            : 2010-01-25 13:38 (56 days old)
> > Handled-By      : NeilBrown <neilb@suse.de>
> > Patch           : https://bugzilla.kernel.org/attachment.cgi?id=25085
> >
> 
> This is supposed to be fixed by Eric's patch which is now in upstream.

Thanks, it's been closed already.

Rafael
