Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2DWE7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 00:59:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48856 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2DWE7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:23 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-a7-4f94e1a89c84
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/11] trace-cmd: libparsevent cleanups - part 2
Date: Mon, 23 Apr 2012 13:58:27 +0900
Message-Id: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second part of my libparsevent cleanups. The patches are
based on my previous patch set [1].

Any comments are welcome.
Thanks.

[1] https://lkml.org/lkml/2012/4/8/177


Namhyung Kim (11):
  parse-events: Free flag/sym field on failure path
  parse-events: Fix freeing arg on process_dynamic_array()
  parse-events: Get rid of handling concatenation on event_read_print
  parse-events: Remove unused arg->dynarray.index
  parse-events: Use proper function parameter type
  parse-events: Pass string type argument to args
  parse-events: Do not call add_event() again if allocation failed
  parse-events: Fix some comments
  parse-filter: Check result of malloc() during reading token
  parse-filter: Fix signature of create_arg_item()
  parse-filter: Check return value of arg_to_str()

 parse-events.c |   62 ++++++++++++++++++++++----------------------------------
 parse-events.h |    1 -
 parse-filter.c |   22 ++++++++++++++------
 3 files changed, 40 insertions(+), 45 deletions(-)

-- 
1.7.10

