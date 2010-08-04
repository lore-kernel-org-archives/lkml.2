Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0HDIhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:37:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:38601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab0HDIhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:37:22 -0400
Message-ID: <4C5926BD.9000804@kernel.org>
Date: Wed, 04 Aug 2010 10:37:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu for v2.6.36
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 08:36:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

to receive percpu changes.  It contains two patches to allow percpu
allocator to be usable before slab comes online.  slab branch will
have patches to make it use percpu allocator during boot strapping
instead of dancing around static memory.

Thanks.

Tejun Heo (2):
      percpu: make @dyn_size always mean min dyn_size in first chunk init functions
      percpu: allow limited allocation before slab is online

 include/linux/percpu.h |   20 ++++++++---
 init/main.c            |    1 +
 mm/percpu.c            |   85 +++++++++++++++++++++++++++--------------------
 3 files changed, 64 insertions(+), 42 deletions(-)

--
tejun
