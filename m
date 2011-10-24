Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1JXK5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:57:11 -0400
Received: from dns1.mips.com ([12.201.5.69]:57943 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1JXK5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:57:10 -0400
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <linux-kernel@vger.kernel.org>
CC: Deng-Cheng Zhu <dczhu@mips.com>
Subject: [RFC PATCH 0/2] tools/perf: fix the event grouping functionality
Date: Mon, 24 Oct 2011 18:56:58 +0800
Message-ID: <1319453820-12992-1-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: Wmf//6Ih5LbM8L39MrJ1jA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches relating to the event state and group_fd of grouped events at
creation.

Deng-Cheng Zhu (2):
  tools/perf: Don't set attr->disabled when doing grouping
  tools/perf: Make group_fd static and move its place in
    __perf_evsel__open()

 tools/perf/builtin-record.c |    6 +++---
 tools/perf/builtin-stat.c   |    3 ++-
 tools/perf/util/evsel.c     |    3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

