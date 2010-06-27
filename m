Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0F0QbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 12:31:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:48819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0F0Qa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 12:30:57 -0400
Message-ID: <4C277C76.8060704@kernel.org>
Date: Sun, 27 Jun 2010 18:29:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Pavel V. Panteleev" <pp_84@mail.ru>, Cliff Wickman <cpw@sgi.com>
Subject: [GIT PULL] percpu for v2.6.35-rc3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Jun 2010 16:30:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu changes for
2.6.35-rc3.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

There are two fixes.  One is to fix two trivial and harmless bugs in
pcpu_build_alloc_info().  The other fixes a bug in
per_cpu_ptr_to_phys() which can cause oops during operations which
need to map percpu addresses to physical addresses such as kdump or
reading /sys/devices/system/cpu/cpuN/crash_notes.

Thanks.

Pavel V. Panteleev (1):
      percpu: fix trivial bugs in pcpu_build_alloc_info()

Tejun Heo (1):
      percpu: fix first chunk match in per_cpu_ptr_to_phys()

 mm/percpu.c |   36 ++++++++++++++++++++++++++++++------
 1 files changed, 30 insertions(+), 6 deletions(-)

--
tejun
