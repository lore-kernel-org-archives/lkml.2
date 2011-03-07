Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1CGUOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:14:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab1CGUN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:13:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, phan@redhat.com
Subject: [PATCH 0/2] perf: fix events overflow in top command
Date: Mon,  7 Mar 2011 21:13:39 +0100
Message-Id: <1299528821-17521-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

there's a way to crash perf top command by specifying multiple
events. Attached is the fix and change to eliminate the events
output in case many events are specified.

attached patches:
1/2 - perf,top: fix events overflow in top command
2/2 - perf,top: dont let events to eat up whole header line

wbr,
jirka
---
 tools/perf/util/top.c |   48 ++++++++++++++++++++++++++++++++++--------------
 1 files changed, 34 insertions(+), 14 deletions(-)
