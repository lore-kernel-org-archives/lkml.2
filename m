Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0ITTsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:48:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0ITTsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:48:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: 2.6.36-rc4-git5: Reported regressions from 2.6.35
Date: Mon, 20 Sep 2010 21:47:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>, harn-solo@gmx.de
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera> <AANLkTinLR0Js0ueVOGEkbs27d4FEH14c=1wuhUqPsiHx@mail.gmail.com>
In-Reply-To: <AANLkTinLR0Js0ueVOGEkbs27d4FEH14c=1wuhUqPsiHx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202147.39971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimming the CC list.]

On Monday, September 20, 2010, Sedat Dilek wrote:
> Hi Rafael,
> 
> can you please add the following, Thanks in advance.
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=18872
> > Subject         : Radeon KMS r100 and STR problems
> > Submitter       : Richard Mittendorfer <delist@gmx.net>
> > Date            : 2010-09-17 18:26 (4 days old)
> > Message-ID      : <20100917202647.aa4b6300.delist@gmx.net>
> > References      : http://marc.info/?l=linux-kernel&m=128474802809779&w=2
> 
> On Mon, Sep 20, 2010 at 8:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message contains a list of some regressions from 2.6.35,
> > for which there are no fixes in the mainline known to the tracking team.
> > If any of them have been fixed already, please let us know.
> >
> > If you know of any other unresolved regressions from 2.6.35, please let us
> > know either and we'll add them to the list.  Also, please let us know
> > if any of the entries below are invalid.
> >
> > Each entry from the list will be sent additionally in an automatic reply
> > to this message with CCs to the people involved in reporting and handling
> > the issue.
> >
> >
> > Listed regressions statistics:
> >
> >  Date          Total  Pending  Unresolved
> >  ----------------------------------------
> >  2010-09-20       38       15          15
> >  2010-09-12       28       14          13
> >  2010-08-30       21       16          15
> >
> >
> > Unresolved regressions
> 
> Hi Rafael,
> 
> can you please add the following Bug, Thanks in advance.
> 
> Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=16140
> Subject         : Suspend To RAM/ Resume broken - Radeon KMS on RV250
> Submitter       : Michael Long <harn-solo@gmx.de>
> Date            : 2010-06-06 09:52
> Message-ID      : ???
> References      : ???
> 
> What is with "Regression:	No" in the BR? Change?

Yes, but according to the comments in there, it is a regression from 2.6.33.
I marked is as such and linked it to the appropriate meta-bug entry, but we're
not going to list it, because we only list post-2.6.34 (and post-2.6.35)
regressions in the current cycle.

Thanks,
Rafael
