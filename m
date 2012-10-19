Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2JSI1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:27:39 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62694 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2JSI1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:27:37 -0400
MIME-Version: 1.0
Date: Fri, 19 Oct 2012 10:27:35 +0200
Message-ID: <CABPqkBS9Wm2c=fnaQzKycXnuqRtAocAZ4qQ7ToAaaVDQbtVoyA@mail.gmail.com>
Subject: [BUG] perf list: --help option not implemented
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

When I run perf list, I see:

$ perf list
  ..
  rNNN                                               [Raw hardware
event descriptor]
  cpu/t1=v1[,t2=v2,t3 ...]/modifier                  [Raw hardware
event descriptor]
   (see 'perf list --help' on how to encode it)

But:
$ perf list --help
$

Shows nothing. Looked at the code and I don't see where you handle the --help
option. You need some help to figure out what the modifiers are.

Am I missing something here?
