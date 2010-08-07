Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210Ab0HGDHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 23:07:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43432 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0HGDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 23:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=wD4IUBE/lEZ09Q1V9/AUWggjfTVpuU3dvwtLz5nCFavZu211sP3zEjqiOhn0GdGz9e
         zkkl/6DE7vOBSTZyioL9I1PM268+nwLNCdkyfVM6/RdYPa51U+ugZA5kCnrMjyN0EMyu
         Dd6KPUv5lbIEWAWe0IbMWz/Rf/FBgbPomqC3E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] bkl core updates for 2.6.36
Date: Sat,  7 Aug 2010 05:07:10 +0200
Message-Id: <1281150430-5510-1-git-send-regression-fweisbec@gmail.com>
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

Arnd Bergmann (2):
      init: Remove the BKL from startup code
      do_coredump: Do not take BKL


 fs/exec.c            |    7 -------
 init/main.c          |    5 -----
 kernel/trace/trace.c |    8 --------
 3 files changed, 0 insertions(+), 20 deletions(-)
