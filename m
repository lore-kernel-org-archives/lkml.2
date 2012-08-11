Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2HKNr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 09:47:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33929 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2HKNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 09:47:58 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] perf tools: Can't find util/unwind.h
Date: Sat, 11 Aug 2012 22:47:45 +0900
Message-ID: <87ipcpbkvy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Your current perf/core branch fails to build like this:

  $ make
  Makefile:494: No libunwind found. Please install libunwind >= 0.99
      CC perf.o
  make: *** No rule to make target `util/unwind.h', needed by `builtin-annotate.o'.  Stop.
  
  $ ls util/unwind*
  ls: cannot access util/unwind*: No such file or directory

Forgot to add the files?

Thanks,
Namhyung
