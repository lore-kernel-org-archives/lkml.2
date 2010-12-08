Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0LHB4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:56:00 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:39928 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab0LHByw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:54:52 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,313,1288569600"; 
   d="scan'208";a="229194263"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <daahern@cisco.com>
Subject: [PATCH 0/2] perf tools: add reference timestamp and use it in time history dump
Date: Tue,  7 Dec 2010 18:54:43 -0700
Message-Id: <1291773285-16254-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern (2):
  perf tools: Add reference timestamp to perf header
  perf tools: Add option to show time history of event samples

 tools/perf/builtin-record.c |    8 +++
 tools/perf/builtin-report.c |  131 ++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/header.c    |   51 +++++++++++++++++
 tools/perf/util/header.h    |    3 +
 tools/perf/util/session.c   |   26 +++++++++
 5 files changed, 217 insertions(+), 2 deletions(-)

-- 
1.7.2.3

