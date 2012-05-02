Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2EBQ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 12:27:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38518 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2EBQ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 12:27:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Wed,  2 May 2012 13:27:02 -0300
Message-Id: <1335976024-13067-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 33ff581eddf744ea91a50d46c2f0961b375a9595:

  perf symbols: Read plt symbols from proper symtab_type binary (2012-04-20 13:34:49 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 5622c07b4741e0afd7607bce6e850b76eeb23210:

  perf stat: Fix case where guest/host monitoring is not supported by kernel (2012-05-01 14:20:00 -0300)

----------------------------------------------------------------
Fixes for perf/urgent:

. Add fallback in 'perf stat' for kernels that don't support
  perf_event_attr.exclude_guest, from Stephane Eranian.

. Fix build id cache add routine to take the size of the buffer and not of a
  pointer, from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (1):
      perf build-id: Fix filename size calculation

Stephane Eranian (1):
      perf stat: Fix case where guest/host monitoring is not supported by kernel

 tools/perf/builtin-stat.c |   33 +++++++++++++++++++++++++++++----
 tools/perf/util/header.c  |    2 +-
 2 files changed, 30 insertions(+), 5 deletions(-)
