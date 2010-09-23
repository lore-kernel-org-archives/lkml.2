Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0IWVnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:43:46 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:47915 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752555Ab0IWVnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:43:45 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 17:43:45 EDT
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: arjan@linux.intel.com, nhorman@tuxdriver.com
Cc: tomk@rgmadvisors.com, danb@rgmadvisors.com, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 0/2] irqbalance: Fixes for CPU count
Date: Thu, 23 Sep 2010 16:38:05 -0500
Message-Id: <1285277887-14190-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my 2.6.32 machines I noticed irqbalance was always rescanning the CPU
topology, and never entered power_mode because the CPU counts did not
match.  The following two patches fix the CPU detection in irqbalance.

Shawn Bohrer (2):
  Fix detection of CPUs in sysfs
  Special interrupt counts line NMI may start with a space

 cputree.c        |    3 ++-
 procinterrupts.c |   24 +++++++++++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

