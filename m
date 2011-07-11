Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab1GKTU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:20:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46543 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab1GKTU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:20:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin <marogge@onlinehome.de>
Subject: Re: [Bug #37752] Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine with 82915G/GV/910GL Integrated Graphics Controller
Date: Mon, 11 Jul 2011 21:21:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.A9H.vlYGOB@chimera> <201107112035.36002.marogge@onlinehome.de>
In-Reply-To: <201107112035.36002.marogge@onlinehome.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107112121.22651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 11, 2011, Martin wrote:
> On Sunday 10 July 2011 12:58:54 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37752
> > Subject		: Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine 
> with
> > 82915G/GV/910GL Integrated Graphics Controller Submitter	: Martin Rogge
> > <marogge@onlinehome.de>
> > Date		: 2011-06-17 13:02 (24 days old)
> 
> I have verified today that both 2.6.39.3 and 3.0-rc6 still show the problem. 
> As before, 3.0-rc6 seems to have a longer uptime than 3.6.39.3. Both times I 
> did not catch a proper kernel panic. The machine simply froze.

Thanks for the update.

Rafael
