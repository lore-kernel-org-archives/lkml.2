Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1BMK54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 05:57:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab1BMK5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 05:57:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [Bug #28622] radeon video lockup
Date: Sun, 13 Feb 2011 11:57:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>,
        DRI <dri-devel@lists.freedesktop.org>
References: <9Pzlq5PlEtH.A.DU.efxVNB@chimera> <1z1FRILH7uF.A.ib.rfxVNB@chimera> <alpine.DEB.2.00.1102121610460.4146@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1102121610460.4146@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102131157.27657.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 13, 2011, david@lang.hm wrote:
> On Sun, 13 Feb 2011, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.36 and 2.6.37.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28622
> > Subject		: radeon video lockup
> > Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
> > Date		: 2011-02-08 17:48 (5 days old)
> 
> hmm, I've occasionally been expericancing what sounds like a similar 
> issue.
> 
> the screen locks, it doesn't respond to the keyboard (but caps lock still 
> works), frequently the mouse pointer still moves, but you can't click on 
> anything.
> 
> it ususally happens to me a few min after starting firefox (with 10-15 
> windows holding a couple hundred tabs), so it could also be a firefox bug 
> if it can capture the input and not release it.
> 
> I've experianced this on my T61 laptop, and my work machine (Radeon X1300 
> series)
> 
> I'm currently running ubuntu 10.10 which is 2.6.35-25, so if it is the 
> same problem, it wasn't introduced between 2.6.36 and 2.6.37.
> 
> like the OP of the bug report, this is not something that happens 
> frequently, but I don't do much that stresses the video, so starting all 
> these tabs is about as hard as I drive it.

Thanks for the info, added dri-devel to the CC list.

Rafael
