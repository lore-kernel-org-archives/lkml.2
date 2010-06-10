Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab0FJPjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:39:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336Ab0FJPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:39:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Organization: SiSK
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create duplicate filename ... XVR-600 related?
Date: Thu, 10 Jun 2010 17:37:25 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <201006100026.44762.rjw@sisk.pl> <19472.47559.578732.941291@pilspetsen.it.uu.se>
In-Reply-To: <19472.47559.578732.941291@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101737.25915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 10, 2010, Mikael Pettersson wrote:
> Rafael J. Wysocki writes:
>  > On Wednesday, June 09, 2010, Mikael Pettersson wrote:
>  > > Rafael J. Wysocki wrote:
>  > > > This message has been generated automatically as a part of a summary report
>  > > > of recent regressions.
>  > > > 
>  > > > The following bug entry is on the current list of known regressions
>  > > > from 2.6.34.  Please verify if it still should be listed and let the tracking team
>  > > > know (either way).
>  > > > 
>  > > > 
>  > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16161
>  > > > Subject		: [2.6.35-rc1 regression] sysfs: cannot create duplicate filename =
>  > > > ... XVR-600 related?
>  > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>  > > > Date		: 2010-06-01 19:57 (8 days old)
>  > > > Message-ID	: <19461.26166.427857.612983@pilspetsen.it.uu.se>
>  > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D127542227511925&w=3D2
>  > > 
>  > > The bug is still there in 2.6.35-rc2. I haven't checked post-rc2 git snapshots.
>  > 
>  > Please test post-rc2 too.
> 
> The bug is still there in 2.6.35-rc2-git4.

Thanks for the confirmation.

Rafael
