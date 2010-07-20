Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967434Ab0GTAq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:46:58 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13673 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967393Ab0GTAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:46:55 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 0/2] trace-cmd: Fix a couple of crashes.
Date: Mon, 19 Jul 2010 17:46:48 -0700
Message-Id: <1279586810-29859-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 20 Jul 2010 00:46:54.0997 (UTC) FILETIME=[0CEA7450:01CB27A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been playing around with trace-cmd and kernelshark on mips64
and have encountered a couple of crashes.

These two patches fix the crashes.  But what is slightly less clear, is
if they may cause valid trace events to be omitted. I don't think they do.

In any event here they are.

David Daney (2):
  trace-cmd: Don't try to read unmapped memory (v2).
  trace-cmd: Don't SIGSEGV in trace-graph.c:load_handle

 parse-events.c |    5 +++++
 trace-graph.c  |    2 ++
 trace-input.c  |    3 ++-
 3 files changed, 9 insertions(+), 1 deletions(-)

