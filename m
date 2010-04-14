Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0DNP7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:59:47 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:38118 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab0DNP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PBYGTM5lpFC4zgyQmhkpdApusT3V1Wc8+FJxUYVnpMII/1sU/O2aX93apO7YdFwARY
         +2oqBaOYQwtd7DhyO2XaH+bu/HmrBz6mrKaa5wKiDDxlfCU3QNfRvSdNLZ9VHj3YMVM3
         ZPMt52dF1GYpvQvc2P1t0om/G4Fp22KpNxEfc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf updates
Date: Wed, 14 Apr 2010 17:59:39 +0200
Message-Id: <1271260779-2008-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf: Store active software events in a hashlist
      perf: Make clock software events consistent with general exclusion rules


 include/linux/perf_event.h |   12 ++
 kernel/perf_event.c        |  255 +++++++++++++++++++++++++++++++------------
 2 files changed, 196 insertions(+), 71 deletions(-)
