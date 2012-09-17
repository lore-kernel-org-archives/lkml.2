Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab2IQUvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:51:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:49213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2IQUvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:51:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [RFC 0/4] Some libtraceevent cleanups/simplifications
Date: Mon, 17 Sep 2012 17:50:45 -0300
Message-Id: <1347915049-19093-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

	Please take a look, while looking at how to do some stuff in 'perf
test' just for parsing the /format file I ended up with this series, lemme know
if I can add your Acked-by and push via my perf/core branch.

- Arnaldo

Arnaldo Carvalho de Melo (4):
  tools lib traceevent: Use asprintf were applicable
  tools lib traceevent: Use calloc were applicable
  tools lib traceevent: Fix afterlife gotos
  tools lib traceevent: Remove some die() calls

 tools/lib/traceevent/event-parse.c |  357 ++++++++++++++++++++++--------------
 1 file changed, 223 insertions(+), 134 deletions(-)

-- 
1.7.9.2.358.g22243

