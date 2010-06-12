Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0FLQPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 12:15:20 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:64228 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0FLQPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 12:15:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19475.45707.157935.788004@pilspetsen.it.uu.se>
Date: Sat, 12 Jun 2010 18:15:07 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create duplicate filename ... XVR-600 related?
In-Reply-To: <19472.47559.578732.941291@pilspetsen.it.uu.se>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
	<C9Q3XEnHPeG.A.fIG.P8rDMB@chimera>
	<19471.35731.889910.990185@pilspetsen.it.uu.se>
	<201006100026.44762.rjw@sisk.pl>
	<19472.47559.578732.941291@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
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

The bug appears to be gone in 2.6.35-rc3.  I don't know which
commit actually fixed it.
