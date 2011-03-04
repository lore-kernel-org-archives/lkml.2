Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab1CDAiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:38:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1CDAiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xd8R2B6CIjb+ENUdIKSDSjWib0KFT4WVAz67HvHb1xDneCWJMNOyaInaJxWBcSzm5n
         5V9Cz/5332ez7fWel6GpTPUlsPod0PlzKrBv1ivSNaZWsegV/jPkb34fO1bFB8jI5QhD
         +yYUQKp5KJgsRvaEOAqXr/CfA4vcGyWA4BZV8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] perf updates
Date: Fri,  4 Mar 2011 01:38:30 +0100
Message-Id: <1299199110-3079-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1298733093-3928-1-git-send-email-fweisbec@gmail.com>
References: <1298733093-3928-1-git-send-email-fweisbec@gmail.com>
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
      perf: Fix missing strndup declaration
      perf: Fix undefined PyVarObject_HEAD_INIT in python 2.5


 tools/perf/util/python.c    |    5 +++++
 tools/perf/util/strfilter.c |    1 -
 2 files changed, 5 insertions(+), 1 deletions(-)
