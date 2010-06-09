Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab0FIOZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 10:25:06 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:60963 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757792Ab0FIOZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:25:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19471.35731.889910.990185@pilspetsen.it.uu.se>
Date: Wed, 9 Jun 2010 14:39:47 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create duplicate filename ... XVR-600 related?
In-Reply-To: <C9Q3XEnHPeG.A.fIG.P8rDMB@chimera>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
	<C9Q3XEnHPeG.A.fIG.P8rDMB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16161
> Subject		: [2.6.35-rc1 regression] sysfs: cannot create duplicate filename =
> ... XVR-600 related?
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2010-06-01 19:57 (8 days old)
> Message-ID	: <19461.26166.427857.612983@pilspetsen.it.uu.se>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127542227511925&w=3D2

The bug is still there in 2.6.35-rc2. I haven't checked post-rc2 git snapshots.
