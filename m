Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab0JRVgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:36:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0JRVgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:36:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #19072] [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
Date: Mon, 18 Oct 2010 23:35:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera> <7N-qxsaxKCN.A.i4C.yk1uMB@chimera> <19643.64049.949858.105680@pilspetsen.it.uu.se>
In-Reply-To: <19643.64049.949858.105680@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010182335.26603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 18, 2010, Mikael Pettersson wrote:
> On Sun, 17 Oct 2010 22:21:42 +0200 (CEST), Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D19072
> > Subject		: [2.6.36-rc regression] occasional complete system hangs on sparc=
> > 64 SMP
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2010-09-23 17:02 (25 days old)
> > Message-ID	: <<19611.34846.813757.309183@pilspetsen.it.uu.se>>
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D128526136531048&w=3D2
> 
> I've not been able to reproduce it yet with 2.6.36-rc7, but there's
> been no known recent bugfix in this area so whether the bug is fixed
> or not is unknown.  If I've not been able to reproduce it on -rc7 or
> -rc8 after next weekend we could close the bug.

OK, please close the bug when you think it's time or let me know if you can't
close it yourself.

Thanks,
Rafael
