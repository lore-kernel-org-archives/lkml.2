Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2DOQbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:31:34 -0400
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:36091 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab2DOQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:31:33 -0400
Date: Sun, 15 Apr 2012 18:31:30 +0200
From: David Madore <david+ml@madore.org>
To: linux-kernel@vger.kernel.org
Subject: watchdog (iTCO_wdt) heartbeat/timeout value is ignored after
 suspend-to-{RAM,disk}
Message-ID: <20120415163130.GA12802@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

My motherboard's chipset (ICH7) has a watchdog handled by the iTCO_wdt
driver.  This module takes a "heartbeat" parameter which specifies the
timeout after which the system is reset.

It appears that this parameter no longer has an effect after the
system is suspended (to RAM or disk) and then resumed: I use
heartbeat=90, which initially works, but after a resume, the system is
rebooted despite the wd_keepalive daemon writing to the device every
30 seconds or so.

I imagine this is easy to fix.

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
