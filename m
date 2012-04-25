Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab2DYLp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:45:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab2DYLpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:45:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] perf, tool: Fix endian issues
Date: Wed, 25 Apr 2012 13:44:59 +0200
Message-Id: <1335354301-5908-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fixies to properly handle perf.data endians.

Attached patches:
  1/2 perf, tool: Handle different endians properly during symbol load
  2/2 perf, tool: Carry perf_event_attr bitfield throught different endians

thanks,
jirka
---
 tools/perf/util/session.c |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.c  |   33 ++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.h  |   30 ++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 1 deletions(-)
