Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1LIRnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:43:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1LIRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:43:49 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf: working with multithreaded processes with named threads
Date: Fri,  9 Dec 2011 10:43:36 -0700
Message-Id: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.3
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
 tools/perf/util/event.c     |  111 ++++++++++++++++++++++++++++++++----------
 2 files changed, 85 insertions(+), 28 deletions(-)

-- 
1.7.7.3

