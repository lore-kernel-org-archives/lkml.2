Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2DICyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:54:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64221 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2DICyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:38 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-b5-4f824f6c9dbf
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] trace-cmd: Small fixes and cleanups on libparsevent
Date: Mon,  9 Apr 2012 11:54:27 +0900
Message-Id: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

This is a couple of small changes that I found during the flight back to
Korea :). While I'm not finished with reading the whole code, I send what
I have now in the hope that it'd help Frederic's unification work somewhat.
More might come later as I read the remaining parts.

The patch 01 is a workaround to build trace-cmd without installing swig
since I don't have an internet access at that time, so it's independent
to others and can go separately.

Thanks.


Namhyung Kim (7):
  trace-cmd: Add NO_PYTHON option for Makefile
  parse-events: Fix printk_cmp()
  parse-events: Introduce extend_token()
  parse-events: Handle strdup failure cases
  parse-events: Fix a possible memory leak
  parse-events: Handle realloc() failure path
  parse-events: Fix a possibly wrong memory dereference

 Makefile       |    2 +
 parse-events.c |  168 +++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 121 insertions(+), 49 deletions(-)

-- 
1.7.7.6

