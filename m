Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0KVQeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:34:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:46021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0KVQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:34:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Eugene Teo <eugeneteo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/1] perf record: Handle 400 mode in /perf/kallsyms
Date: Mon, 22 Nov 2010 14:33:38 -0200
Message-Id: <1290443619-17379-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf record: Handle restrictive permissions in /proc/{kallsyms,modules}

 tools/perf/builtin-record.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

