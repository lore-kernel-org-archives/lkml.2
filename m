Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0LJTxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:53:22 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49403 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab0LJTxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:53:20 -0500
From: jean.pihet@newoldbits.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 0/3] perf, tools: new power trace API
Date: Fri, 10 Dec 2010 20:51:58 +0100
Message-Id: <1292010721-17426-1-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Provides:
. calls to machine_suspend trace point,
. OMAP support,
. API Documentation

Applies on top of Thomas's 8 latest power trace API patches, cf.
http://marc.info/?l=linux-kernel&m=129130827309354&w=2

Jean Pihet (3):
  perf: add calls to suspend trace point
  perf: add OMAP support for the new power events
  tools, perf: Documentation for the power events API

 Documentation/trace/events-power.txt |   90 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/pm34xx.c         |    7 +++
 arch/arm/mach-omap2/powerdomain.c    |    3 +
 arch/arm/plat-omap/clock.c           |   13 ++++-
 kernel/power/suspend.c               |    3 +
 5 files changed, 113 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/trace/events-power.txt

-- 
1.7.2.3

