Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268Ab2DKU55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:57:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45395 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2DKU54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:57:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Wed, 11 Apr 2012 17:57:42 -0300
Message-Id: <1334177863-18820-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

	Now there are 6 outstanding fixes in this branch.

- Arnaldo

The following changes since commit 31d68e7b66f168e623902e194af1e52b8cf75d71:

  perf annotate: Validate addr in symbol__inc_addr_samples (2012-04-05 19:51:14 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 7fb0a5ee8889488f7568ffddffeb66ddeb50917e:

  perf kvm: Finding struct machine fails for PERF_RECORD_MMAP (2012-04-11 11:45:12 -0300)

----------------------------------------------------------------
One more fix for perf/urgent:

. Fix mmap processing for guest kernels, from Nikunj A. Dadhania.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Nikunj A. Dadhania (1):
      perf kvm: Finding struct machine fails for PERF_RECORD_MMAP

 tools/perf/util/session.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)
