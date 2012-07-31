Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2GaEbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:31:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2GaEbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:31:52 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] limit guest messages to once in perf kvm top
Date: Mon, 30 Jul 2012 22:31:31 -0600
Message-Id: <1343709095-7089-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some refactoring so that strlist and intlist have a common base - rblist.
>From there use intlist to only show guest messages once.

David Ahern (4):
  perf tool: introducing rblist
  perf tool: change strlist to use the new rblist
  perf tool: introduce intlist
  perf kvm top: limit guest kernel info message to once

 tools/perf/Makefile       |    4 ++
 tools/perf/builtin-top.c  |   13 ++++-
 tools/perf/util/intlist.c |  101 +++++++++++++++++++++++++++++++++++
 tools/perf/util/intlist.h |   75 ++++++++++++++++++++++++++
 tools/perf/util/rblist.c  |  107 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/rblist.h  |   47 ++++++++++++++++
 tools/perf/util/strlist.c |  130 ++++++++++++++++++---------------------------
 tools/perf/util/strlist.h |   11 ++--
 8 files changed, 402 insertions(+), 86 deletions(-)
 create mode 100644 tools/perf/util/intlist.c
 create mode 100644 tools/perf/util/intlist.h
 create mode 100644 tools/perf/util/rblist.c
 create mode 100644 tools/perf/util/rblist.h

-- 
1.7.10.1

