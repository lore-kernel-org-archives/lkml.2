Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2ILPQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:16:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42734 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2ILPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:16:35 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3 v2] perf: precise mode and exclude_guest
Date: Wed, 12 Sep 2012 09:16:27 -0600
Message-Id: <1347462990-29481-1-git-send-email-dsahern@gmail.com>
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

v2: updated commit messages for patches 1 and 2

 arch/x86/kernel/cpu/perf_event.c |    6 ++++++
 tools/perf/builtin-record.c      |    5 +++++
 tools/perf/builtin-top.c         |    4 ++++
 tools/perf/util/parse-events.c   |    3 +++
 4 files changed, 18 insertions(+)

-- 
1.7.10.1

