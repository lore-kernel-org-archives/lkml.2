Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1LVSaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:30:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56818 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1LVSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:30:12 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf: working with multithreaded processes with named threads
Date: Thu, 22 Dec 2011 11:30:00 -0700
Message-Id: <1324578603-12762-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One bug fix plus a couple of enhancements to improve handling of
named threads.

David Ahern (3):
  perf: fix comm for processes with named threads
  perf: look up thread names for system wide profiling
  perf script: look up thread using tid instead of pid

 tools/perf/builtin-script.c |    2 +-
 tools/perf/util/event.c     |  112 ++++++++++++++++++++++++++++++++----------
 2 files changed, 86 insertions(+), 28 deletions(-)

-- 
1.7.7.4

