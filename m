Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab0FBUlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:41:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660Ab0FBUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:40:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Michal Marek <mmarek@suse.cz>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] Perf improvements for .36 (perf/core)
Date: Wed,  2 Jun 2010 17:40:11 -0300
Message-Id: <1275511215-25703-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	I'll keep perf/urgent for .35 stuff, perf/core now has only things
for .36 and I'm merging perf/urgent into perf/core when you pull from it.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf tools: Make target to generate self contained source tarball

Stephane Eranian (3):
  perf report: Make -D print sampled CPU
  perf tools: Add the ability to specify list of cpus to monitor
  perf buildid: add perfconfig option to specify buildid cache dir

