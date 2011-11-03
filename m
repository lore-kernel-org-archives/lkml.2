Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1KCKSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:18:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40322 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1KCKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:18:50 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Con Kolivas <con@kolivas.org>
Subject: Re: [ANNOUNCE] 3.1.0-ck1
Date: Thu, 3 Nov 2011 11:18:21 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1636461.EdGrGCQCuj@quad>
In-Reply-To: <1636461.EdGrGCQCuj@quad>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111031118.21407.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> These are patches designed to improve system responsiveness and
> interactivity with specific emphasis on the desktop, but suitable to any
> commodity hardware workload.
>
> As it may take some time to get a kernel.org account, I have started
> hosting these patches exclusively on my site for now.
>
>
> Apply to 3.1.x:
> http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/patch-3.1.0-ck1.bz2

Tried here with Mini2440 (=ARM arch) to compile:

[...]
In file included from kernel/sched.c:2:0:
kernel/sched_bfs.c: In function 'schedule':
kernel/sched_bfs.c:3224:4: error: implicit declaration of function 'prefetch'
[...]

> Broken out tarball:
> http://ck.kolivas.org/patches/3.0/3.1/3.1.0-ck1/3.1.0-ck1-broken-out.tar.bz2

This ^ one I tried to apply, but it fails with:
[...]
patching file include/linux/sched.h
Hunk #1 FAILED at 1600.
Hunk #2 FAILED at 1647.
2 out of 2 hunks FAILED -- rejects in file include/linux/sched.h
can't find file to patch at input line 214
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|Index: linux-3.1-ck/kernel/sched_bfs.c
|===================================================================
|--- linux-3.1-ck.orig/kernel/sched_bfs.c	2011-11-03 14:44:23.000000000 +1100
|+++ linux-3.1-ck/kernel/sched_bfs.c	2011-11-03 14:46:02.157115770 +1100
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
[...]

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
