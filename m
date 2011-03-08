Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1CHPZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:25:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab1CHPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:29 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=QN5-2iLaNiMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LWxw587X9Ph_3_r0hzYA:9 a=TZ2RATo1mEkx57VEtEuNUm7cmLkA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152158.799699072@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:21:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/9] ktest: queue for 2.6.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm publishing these just to let people know what I plan on pushing
out come 2.6.39 merge window.

Steven Rostedt (9):
      ktest: Print logfile name on failure
      ktest: Start failure timeout on panic too
      ktest: Handle kernels before make oldnoconfig
      ktest: Add manual bisect
      ktest: Add BISECT_SKIP
      ktest: Add BISECT_FILES to run git bisect on paths
      ktest: Fix bug where the test would not end after failure
      ktest: Monitor kernel while running of user tests
      ktest: Add STOP_TEST_AFTER to stop the test after a period of time

----
 tools/testing/ktest/ktest.pl    |  139 +++++++++++++++++++++++++++++++++------
 tools/testing/ktest/sample.conf |   42 ++++++++++++
 2 files changed, 161 insertions(+), 20 deletions(-)
