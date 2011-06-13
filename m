Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1FMRXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:23:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1FMRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:23:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Subject: Re: [Bug #36962] [Regression 2.6.39][nouveau][bisected?] leaving fullscreen XV "crashes" with KDE desktop effects enabled
Date: Mon, 13 Jun 2011 19:24:14 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera> <kTLfM29CaqB.A.xtE.szS9NB@chimera> <BANLkTinhdxrttCpGBtCMOZDYJJhAR=1zQRnew3t2=SxUYCSiNA@mail.gmail.com>
In-Reply-To: <BANLkTinhdxrttCpGBtCMOZDYJJhAR=1zQRnew3t2=SxUYCSiNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106131924.14715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 13, 2011, Jan Seiffert wrote:
> 2011/6/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=36962
> > Subject         : [Regression 2.6.39][nouveau][bisected?] leaving fullscreen XV "crashes" with KDE desktop effects enabled
> > Submitter       : Jan Seiffert <kaffeemonster@googlemail.com>
> > Date            : 2011-05-25 2:32 (19 days old)
> > Message-ID      : <BANLkTimd6nvXTbn2hM+cKDNKFpxzsQLHog@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=130629073407685&w=2
> >
> >
> >
> 
> Not resolved, so should still be listed.
> 
> Changes since last test:
> KDE-Version += 0.0.1 == 4.6.3
> Only changes color/form of visible corruption, does not change X11 hang
> 
> With 2.6.39.1, leaving fullscreen XV creates heavy corruption, closing
> mplayer lets X11 hang. Machine still alive, can be remote rebooted,
> this makes it to the logs:
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR INVALID_VALUE
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
> [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 3 class
> 0x5039 mthd 0x0224 data 0x21949000
> [drm] nouveau 0000:01:00.0: VM: trapped read at 0x002000f000 on ch 2
> [0x00000aa0] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
> [drm] nouveau 0000:01:00.0: PGRAPH - ILLEGAL_MTHD
> [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 3 class
> 0x5039 mthd 0x0800 data 0x00000000
> ... (and so on)
> 
> With 3.0.0-rc2+ (git from hour ago), leaving fullscreen XV creates
> heavy corruption, closing mplayer lets X11 "half-hang" (unusable, but
> could switch to console, this is new), any other draw (opening the
> KDE.Menu) lets it totally hang, machine still alive, could be remote
> rebooted, this makes it to the logs:
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
> [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 5 class
> 0x8297 mthd 0x1360 data 0x00000001
> [drm] nouveau 0000:01:00.0: VM: trapped write at 0x002000f004 on ch 2
> [0x00000aa0] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
> [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 5 class
> 0x8297 mthd 0x1340 data 0x00008006
> [drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE

Thanks for the update.

Rafael
