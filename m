Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1JYIch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:32:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1JYIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:32:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Tue, 25 Oct 2011 10:35:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201110132145.42270.rjw@sisk.pl> <20111025135244.710e43fa@notabene.brown> <12555.1319528840@turing-police.cc.vt.edu>
In-Reply-To: <12555.1319528840@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110251035.02607.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 25, 2011, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 25 Oct 2011 13:52:44 +1100, NeilBrown said:
> > On Mon, 24 Oct 2011 12:23:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> > > On Monday, October 24, 2011, NeilBrown wrote:
> > > > On Sun, 23 Oct 2011 15:16:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > Similarly every system need one process to manage suspend.  It can be my
> > > > daemon or your daemon or Alan's daemon but it cannot be 2 or more of them
> > > > running at the same time as that doesn't make any more sense than having
> > > > systemd and init running at the same time.
> > >
> > > I agree that it doesn't makes sense.  I don't agree that it implies people
> > > won't try to do that.
> >
> > Does that matter?  If they complain, tell them it isn't a supported
> > configuration.
> 
> We however *should* design things in such a way that if a second one is started
> up, it tosses a nice obvious -EIDIOT error of some sort.

Well, that's exactly my point.

Thanks,
Rafael
