Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0CVVZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:25:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0CVVZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:25:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
Date: Mon, 22 Mar 2010 22:28:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Greg KH <gregkh@suse.de>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera> <hTwaxgnIZ2O.A.rhF.SQopLB@chimera> <alpine.LSU.2.00.1003220319360.1726@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1003220319360.1726@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003222228.28268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010, Hugh Dickins wrote:
> On Sun, 21 Mar 2010, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
> > Subject		: lockdep warning during elevator_switch
> > Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Date		: 2010-01-31 23:55 (50 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4
> 
> Yes, it is still a regression 2.6.33.1 (though fixed in 2.6.34-rc1:
> my guess is that it will be left as a regression in 2.6.33-stable,
> since it only happens when you have chosen CONFIG_PROVE_LOCKING=y).

The policy is that we close the regression bugs after they've been fixed in the
Linus' tree, so I'm going to close it now.

If you want it to go into -stable, please let Greg know directly.

Rafael

