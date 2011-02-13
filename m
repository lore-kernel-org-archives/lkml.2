Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1BMXpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:45:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1BMXpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:45:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: 2.6.38-rc4-git5: Reported regressions from 2.6.37
Date: Mon, 14 Feb 2011 00:45:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Nicolas Stransky <Nico@stransky.cx>, sgh@sgh.dk,
        John Linville <linville@tuxdriver.com>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera> <AANLkTikk_1ywKCMkRgRR20h3ApEhc3kdErMDBx9c9T2f@mail.gmail.com> <AANLkTinQnH7YEeuHj3zAZo1RReXSxcQqUxTw1ocTp4R2@mail.gmail.com>
In-Reply-To: <AANLkTinQnH7YEeuHj3zAZo1RReXSxcQqUxTw1ocTp4R2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102140045.05455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 13, 2011, Sedat Dilek wrote:
> On Sun, Feb 13, 2011 at 12:07 PM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
> > On Sat, Feb 12, 2011 at 11:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> This message contains a list of some regressions from 2.6.37,
> >> for which there are no fixes in the mainline known to the tracking team.
> >> If any of them have been fixed already, please let us know.
> >>
> >> If you know of any other unresolved regressions from 2.6.37, please let us
> >> know either and we'll add them to the list.  Also, please let us know
> >> if any of the entries below are invalid.
> >>
> >> Each entry from the list will be sent additionally in an automatic reply
> >> to this message with CCs to the people involved in reporting and handling
> >> the issue.
> >>
> >>
> >> Listed regressions statistics:
> >>
> >>  Date          Total  Pending  Unresolved
> >>  ----------------------------------------
> >>  2011-02-12       39       20          18
> >>  2011-02-03       19       11           7
> >>
> >>
> >> Unresolved regressions
> >> ----------------------
> >
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=27382
> >> Subject         : ath5k phy0: gain calibration timeout
> >> Submitter       : Nicolas Stransky <Nico@stransky.cx>
> >> Date            : 2011-01-23 00:18 (21 days old)
> >>
> >
> > As I looked into the BR #27382...
> > The patch by Nick Kossifidis from comment #32 (see [1] and [2]) fixed
> > the problem for two affected users.
> >
> > As I have an ath5k wifi device (but I am not affected) on one of my
> > machines, I could test also.
> >
> > Hey, Nick :-)
> > You promised to send a fix to linux-wireless ML (hope, I didn't oversee it).
> >
> > Raphael, might be good to wait for the promised patch?
> >
> > - Sedat -
> >
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=27382#c32
> > [2] http://www.kernel.org/pub/linux/kernel/people/mickflemm/fastchanfix.patch
> >
> 
> Oops, shame on me... Nick's patch was already sent to l-w ML.
> 
> See "[PATCH] ath5k: Fix fast channel switching" [1].
> 
> Raphael, can you add the reference to the patch to the entry/list?
> Thanks.
> 
> The patch is already in linux-next [2], but I am not sure if it is in
> Linus-tree, already.
> 
> - Sedat -
> 
> [1] https://patchwork.kernel.org/patch/530811/
> [2] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=c210de8f88215db31cf3529c9763fc3124d6e09d

Updated status information, thanks.

Rafael
