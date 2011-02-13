Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1BMLCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:02:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab1BMLCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:02:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: 2.6.38-rc4-git5: Reported regressions from 2.6.37
Date: Sun, 13 Feb 2011 12:02:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Felix Fietkau <nbd@openwrt.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <AANLkTi=RnAgp47OTTk_JaNG79ZTb9nQJwLgJfAH4ip+J@mail.gmail.com>
In-Reply-To: <AANLkTi=RnAgp47OTTk_JaNG79ZTb9nQJwLgJfAH4ip+J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102131202.06789.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 13, 2011, Sedat Dilek wrote:
> On Sat, Feb 12, 2011 at 11:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message contains a list of some regressions from 2.6.37,
> > for which there are no fixes in the mainline known to the tracking team.
> > If any of them have been fixed already, please let us know.
> >
> > If you know of any other unresolved regressions from 2.6.37, please let us
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
> >  2011-02-12       39       20          18
> >  2011-02-03       19       11           7
> >
> >
> > Unresolved regressions
> > ----------------------
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=28442
> > Subject         : 2.6.38-rc3: FUSE (sshfs) hangs under load
> > Submitter       : Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Date            : 2011-02-01 17:54 (12 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/4cd06a344db752f513437138953af191cbe9a691
> > Message-ID      : <20110201175452.GB518@core.coreip.homeip.net>
> > References      : http://marc.info/?l=linux-kernel&m=129658291703679&w=2
> >
> 
> The fix by Felix [1] was accepted already in Linus tree:
> 
> commit fc7c976dc7a565213393ce700d4a6105f037bf20
> "mac80211: fix the skb cloned check in the tx path"
> 
> Please, remove the entry from the list, Thanks.

Thanks, closing.

Rafael
