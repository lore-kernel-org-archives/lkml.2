Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2IJQk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:40:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51992 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2IJQkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:40:25 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf: precise mode and exclude_guest
Date: Mon, 10 Sep 2012 10:40:13 -0600
Message-Id: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully thi wraps up the precise mode-exclude_guest dependency.
I'm sure someone will let me know if I screwed up the attribution
in the second patch.

David Ahern (3):
  perf tool: precise mode requires exclude_guest
  perf: require exclude_guest to use PEBS - kernel side enforcement
  perf tool: give user better message if precise is not supported

 arch/x86/kernel/cpu/perf_event.c |    6 ++++++
 tools/perf/builtin-record.c      |    5 +++++
 tools/perf/builtin-top.c         |    4 ++++
 tools/perf/util/parse-events.c   |    3 +++
 4 files changed, 18 insertions(+)

-- 
1.7.10.1

