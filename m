Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab0FJKJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:09:18 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:62593 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab0FJKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:09:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19472.47559.578732.941291@pilspetsen.it.uu.se>
Date: Thu, 10 Jun 2010 12:09:11 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create duplicate filename ... XVR-600 related?
In-Reply-To: <201006100026.44762.rjw@sisk.pl>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
	<C9Q3XEnHPeG.A.fIG.P8rDMB@chimera>
	<19471.35731.889910.990185@pilspetsen.it.uu.se>
	<201006100026.44762.rjw@sisk.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:
 > On Wednesday, June 09, 2010, Mikael Pettersson wrote:
 > > Rafael J. Wysocki wrote:
 > > > This message has been generated automatically as a part of a summary report
 > > > of recent regressions.
 > > > 
 > > > The following bug entry is on the current list of known regressions
 > > > from 2.6.34.  Please verify if it still should be listed and let the tracking team
 > > > know (either way).
 > > > 
 > > > 
 > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16161
 > > > Subject		: [2.6.35-rc1 regression] sysfs: cannot create duplicate filename =
 > > > ... XVR-600 related?
 > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > > > Date		: 2010-06-01 19:57 (8 days old)
 > > > Message-ID	: <19461.26166.427857.612983@pilspetsen.it.uu.se>
 > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D127542227511925&w=3D2
 > > 
 > > The bug is still there in 2.6.35-rc2. I haven't checked post-rc2 git snapshots.
 > 
 > Please test post-rc2 too.

The bug is still there in 2.6.35-rc2-git4.

/Mikael
