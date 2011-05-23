Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1EWLGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:06:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48057 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1EWLGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JM7t3QeGol+gYKlP0RgGVeH+8m5JkTe3QxI6zWCUWUGdifX+3w7DJTpIxmUZsiIF2N
         zm7SXOFumiF/QO9/9QvS7GPXUQH3tEN1Dnf8VI7c/I8MDd5mQF9jhJ8L7ThX3SwR3kLV
         o5ijLOARTjDPuxeh4M2m36jHMuZqwb2nGdDng=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL] perf tools fixes
Date: Mon, 23 May 2011 13:06:26 +0200
Message-Id: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf tools: Fix sample size bit operations
      perf tools: Fix ommitted mmap data update on remap


 tools/perf/util/event.c   |    2 +-
 tools/perf/util/session.c |   39 ++++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 14 deletions(-)
