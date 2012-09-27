Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2I0E2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:28:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55834 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0E2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:28:47 -0400
X-AuditID: 9c930197-b7b6dae000000e70-db-5063d5fa4e8c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] build error on compiling builtin-trace
Date: Thu, 27 Sep 2012 13:20:28 +0900
Message-ID: <87zk4cumer.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

I've encountered a following error when building current acme/perf/core:

    CC builtin-trace.o
builtin-trace.c:7:22: fatal error: libaudit.h: No such file or directory
compilation terminated.
make: *** [builtin-trace.o] Error 1

It'd better if you post patches to the list before updating your
perf/core branch as many people rebase on the branch regularly.

Thanks,
Namhyung
