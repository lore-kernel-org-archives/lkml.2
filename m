Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0K2XH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:07:26 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:24989 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0K2XHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:07:24 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,277,1288569600"; 
   d="scan'208";a="627872652"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <daahern@cisco.com>
Subject: [PATCH 0/2] perf tools: reference timestamp and time history dump
Date: Mon, 29 Nov 2010 16:07:07 -0700
Message-Id: <1291072029-19178-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch adds a reference timestamp to the perf header. The second
patch uses the reference timestamp to convert kernel timestamps to
time-of-day and outputs each sample.

David Ahern (2):
  perf tools: add reference timestamp to perf header
  perf tools: Add option to show time history of event samples

 tools/perf/builtin-record.c |    8 +++
 tools/perf/builtin-report.c |  120 ++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/header.c    |   51 ++++++++++++++++++
 tools/perf/util/header.h    |    3 +
 tools/perf/util/session.c   |   26 +++++++++
 5 files changed, 206 insertions(+), 2 deletions(-)

-- 
1.7.2.3

