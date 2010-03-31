Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0CaWbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:31:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40504 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab0CaWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:31:08 -0400
Date: Thu, 1 Apr 2010 00:31:06 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: rsc@pengutronix.de
Subject: Issues with Patch: "sched: Improve latencies and throughput"
Message-ID: <20100331223106.GJ10342@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:22:48 up 11 days,  8:12, 23 users,  load average: 1.72, 2.70,
	2.49
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using an arm mx31 embedded cpu with the v2.6.34 Kernelrelease and
realized some issues with the scheduling behaviour the patch "sched:
Improve latencies and throughput" [1] by Mike Galbraith introduced to
the kernel.

When we used the alsa utility aplay to pipe some audio through an
usbaudio device and put some scheduling overhead on the device, the
amount of underruns, due to the not fast enough refilled ring buffer,
was noticable increased with that patch [1] applied. Until we reverse
applied the patch the amount of underruns was appreciable lower.

That in fact is the opposite behaviour to its actual meaning.

[1] 0ec9fab3d186d9cbb00c0f694d4a260d07c198d9

mgr

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
