Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2IMWJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:09:19 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52320 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2IMWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:09:18 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 0/4] perf tools: runtime fixes for Android
Date: Fri, 14 Sep 2012 01:07:39 +0300
Message-Id: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of patches with runtime fixes for Android.

Any comments and suggestions are wellcome.

Thanks,
Irina

Irina Tirdea (4):
  perf tools: remove sscanf extension %as
  perf stat: add compile-time option to disable --big-num
  perf archive: remove -f from the rm command
  perf archive: make f the last parameter for tar

 tools/perf/Makefile                 |    8 ++++++++
 tools/perf/builtin-stat.c           |    8 ++++++++
 tools/perf/config/feature-tests.mak |   12 ++++++++++++
 tools/perf/perf-archive.sh          |    6 +++---
 tools/perf/util/probe-event.c       |   25 ++++++++++++++++++-------
 tools/perf/util/trace-event-parse.c |   18 ++++++++----------
 6 files changed, 57 insertions(+), 20 deletions(-)

-- 
1.7.9.5

