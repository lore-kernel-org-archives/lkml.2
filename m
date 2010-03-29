Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0C2QlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:41:13 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:15448
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754098Ab0C2QlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:41:12 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzzz1202hzzz32i6bh87h2a8h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L01YCD-01-GK0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Date: Mon, 29 Mar 2010 18:36:49 +0200
Message-ID: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
X-OriginalArrivalTime: 29 Mar 2010 16:41:00.0854 (UTC) FILETIME=[9D6D4560:01CACF5E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set unifies performance counter bit masks for x86. All mask
are almost the same for all x86 models and thus can use the same macro
definitions in arch/x86/include/asm/perf_event.h. It removes duplicate
code. There is also a patch that reverts some changes of the big
perf_counter -> perf_event rename.

-Robert


