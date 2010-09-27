Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0I0KkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:40:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37164 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0I0KkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kCQsUyrWYq8w5qOOxnqtR3FCgeYMmfpX4YwoI/f1QiW9Wfnz6ok2dxtotkD2oK/Ng/
         adFHV/SUK9xJUFjDZ7ptvlRpldGWFIFAe5W6YhKZNV9nDY5olJG6twHAsaxNCjCcbPWw
         Iy5S+Ir7ATyxaW2lU5b/ktl+n7l/QoXSikq9I=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] perf cleanups
Date: Mon, 27 Sep 2010 19:39:52 +0900
Message-Id: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to remove some of warnings from sparse.
Please take a look and consider applying it. Any comments
would be welcomed.

Thanks.

---

Namhyung Kim (5):
  perf: Wrap perf_lock_task_context using __cond_lock()
  perf: Annotate lock context on perf_output_begin/end()
  perf: Remove 'extern' on hw_perf_event_init() definition
  perf: Make perf_event_wakeup() static
  perf: Declare hw_perf_{dis,en}able() in perf_event.h

 include/linux/perf_event.h |    8 +++++++-
 kernel/perf_event.c        |   17 +++++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

--
1.7.2.2

