Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab2IMU7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:59:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab2IMU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:59:21 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3 v3] perf: precise mode and exclude_guest
Date: Thu, 13 Sep 2012 14:59:12 -0600
Message-Id: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this wraps up the precise mode-exclude_guest dependency.
I'm sure someone will let me know if I screwed up the attribution
in the second patch.

David Ahern (2):
  perf tool: precise mode requires exclude_guest
  perf tool: give user better message if precise is not supported

Peter Zijlstra (1):
  perf: require exclude_guest to use PEBS - kernel side enforcement

v3: removed extra tab in patch 2
v2: updated commit messages for patches 1 and 2

 arch/x86/kernel/cpu/perf_event.c |    6 ++++++
 tools/perf/builtin-record.c      |    5 +++++
 tools/perf/builtin-top.c         |    4 ++++
 tools/perf/util/parse-events.c   |    3 +++
 4 files changed, 18 insertions(+)

-- 
1.7.10.1

