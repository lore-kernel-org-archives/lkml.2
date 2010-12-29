Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0L2XjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:39:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0L2XjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:39:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #22562] Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
Date: Thu, 30 Dec 2010 00:35:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.JLH.iA8GNB@chimera> <4D1BC4CC.6060700@lwfinger.net>
In-Reply-To: <4D1BC4CC.6060700@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012300035.35107.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 30, 2010, Larry Finger wrote:
> On 12/29/2010 05:06 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22562
> > Subject		: Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2010-11-02 22:32 (58 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
> > Message-ID	: <4CD09166.4060202@lwfinger.net>
> > References	: http://marc.info/?l=linux-kernel&m=128873713207906&w=2
> 
> It is still in 2.6.37-rc8. I got some debugging tips from Alan Stern, but have
> not had time to follow-up. I hope/need to make some progress before 2.6.37 is
> released.

Thanks for the update.

Rafael
