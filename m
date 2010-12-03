Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0LCV2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:28:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52677 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0LCV2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:28:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #22562] Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
Date: Fri, 3 Dec 2010 22:28:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera> <gUkHV_Vc3aE.A.qi.gzC-MB@chimera> <4CF859AA.8010505@lwfinger.net>
In-Reply-To: <4CF859AA.8010505@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012032228.18035.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010, Larry Finger wrote:
> On 12/02/2010 05:41 PM, Rafael J. Wysocki wrote:
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
> > Date		: 2010-11-02 22:32 (31 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
> > Message-ID	: <4CD09166.4060202@lwfinger.net>
> > References	: http://marc.info/?l=linux-kernel&m=128873713207906&w=2
> 
> Still present in 2.6.37-rc4. The box with the problem has been repaired and I
> can now debug the problem again. Any hints would be appreciated.

Thanks for the update.

Rafael
