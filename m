Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0LSSz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 13:55:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39232 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab0LSSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 13:55:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [Bug #22672] Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
Date: Sun, 19 Dec 2010 19:54:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera> <6Ue85L6pKCJ.A.NVF.qffDNB@chimera> <4D0E31FF.9060104@lwfinger.net>
In-Reply-To: <4D0E31FF.9060104@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012191954.32347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 19, 2010, Larry Finger wrote:
> On 12/19/2010 06:34 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22672
> > Subject		: Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2010-11-11 01:56 (39 days old)
> > References	: https://bugs.freedesktop.org/show_bug.cgi?id=31803
> > 		  http://marc.info/?l=linux-kernel&m=128944001311444&w=2
> > 		  http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg02235.html
> > Patch		: https://patchwork.kernel.org/patch/359472/
> > 		  https://patchwork.kernel.org/patch/359502/
> 
> The problem is still present in 2.6.37-rc6.

Thanks for the update.

Rafael
