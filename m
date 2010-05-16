Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0EPW4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:56:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52302 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0EPW4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=EO2BIb0ZXv9CTvRLHV0GjOjj78vRy4eMlFj+X97OG9qyYLarSAwx0W0kXwUoJ5mW8b
         FSN87qWUU0bur5yUa2YaJzBwKCPQReQQjnIzHptD730RaizjTSFQo2QygxZSIO6AeVtF
         2AWNQ46FiOg9SYlVhFVgiwB2iXLmNRV8S+3Js=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Lassabe <frederic.lassabe@gmail.com>
Subject: [GIT PULL] Ptrace bkl removal for 2.6.35-rc1
Date: Mon, 17 May 2010 00:56:20 +0200
Message-Id: <1274050580-21450-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the bkl/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/core

Thanks,
	Frederic
---

Alessio Igor Bogani (1):
      ptrace: Cleanup useless header

Arnd Bergmann (1):
      ptrace: kill BKL in ptrace syscall


 kernel/ptrace.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)
