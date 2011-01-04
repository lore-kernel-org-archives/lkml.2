Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1ADKSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:18:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60739 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1ADKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:18:08 -0500
From: jean.pihet@newoldbits.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org, trenn@suse.de
Cc: linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, rjw@sisk.pl,
        Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 0/3] perf, tools: new power trace API
Date: Tue,  4 Jan 2011 11:17:40 +0100
Message-Id: <1294136263-24020-1-git-send-email-j-pihet@ti.com>
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

