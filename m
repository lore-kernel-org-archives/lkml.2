Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2HGCZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:25:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64210 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2HGCZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:25:21 -0400
From: Palmer Cox <p@lmercox.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] cpupower tools: Fix minor bugs and warnings
Date: Mon,  6 Aug 2012 22:24:42 -0400
Message-Id: <1344306288-12369-1-git-send-email-p@lmercox.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1 and 2 of the series fix a simple issues with the Makefiles
and .gitignore file. Patch 3 fixes a couple trivial warnings. Patch
4 fixes some error checking issues. Path 5 fixes a malloc issue. Patch
6 fixes a sign comparison error by updating how the number of cpu packages
are calculated which I believe also fixes an issue that would arrise if the
package id values are non-contiguous on a particular system.

Palmer Cox (6):
      cpupower tools: Remove brace expansion from clean target
      cpupower tools: Update .gitignore for files created in the debug directories
      cpupower tools: Fix minor warnings
      cpupower tools: Fix issues with sysfs_topology_read_file
      cpupower tools: Fix malloc of cpu_info structure
      cpupower tools: Fix warning and a bug with the cpu package count

 tools/power/cpupower/.gitignore                    |    7 +++
 tools/power/cpupower/Makefile                      |    3 +-
 tools/power/cpupower/debug/i386/Makefile           |    5 +-
 tools/power/cpupower/utils/helpers/helpers.h       |   17 ++++---
 tools/power/cpupower/utils/helpers/sysfs.c         |   19 -------
 tools/power/cpupower/utils/helpers/topology.c      |   53 +++++++++++---------
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |    3 +-
 7 files changed, 52 insertions(+), 55 deletions(-)

