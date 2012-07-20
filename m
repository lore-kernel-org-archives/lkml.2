Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2GTX0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:26:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2GTX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/11] perf tool: assorted cleanups and bug fixes
Date: Fri, 20 Jul 2012 17:25:45 -0600
Message-Id: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

Welcome back from vacation. Some cleanups and bug fixes for 3.6.
Patch 8 should apply to stable if Gleb's and Peter's patches
are backported as well.
 

David Ahern (11):
  perf tool: add machine id to modules debug message
  perf kvm: set name for VM process in guest machine
  perf kvm: guest userspace samples should not be lumped with host
    uspace
  perf kvm: fix bug resolving guest kernel syms - v2
  perf kvm: use strtol for walking guestmount directory
  perf kvm: limit repetitive guestmount message to once per directory
  perf tools: dump exclude_{guest,host}, precise_ip header info too
  perf tool: precise mode requires exclude_guest
  perf top: error handling for counter creation should parallel
    perf-record
  perf tool: give user better message if precise is not supported
  perf kvm top: limit guest kernel info message to once

 tools/perf/builtin-record.c    |    4 ++++
 tools/perf/builtin-top.c       |   24 +++++++++++++++++++----
 tools/perf/util/header.c       |    6 ++++++
 tools/perf/util/map.c          |   41 ++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/map.h          |    1 +
 tools/perf/util/parse-events.c |    3 +++
 tools/perf/util/session.c      |    5 ++++-
 tools/perf/util/symbol.c       |   21 +++++++++++++++++---
 8 files changed, 95 insertions(+), 10 deletions(-)

-- 
1.7.10.1

