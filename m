Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0DVQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:38:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0DVQid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:38:33 -0400
Message-ID: <4BD07B84.1070608@kernel.org>
Date: Thu, 22 Apr 2010 18:38:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: jan.kiszka@web.de
Subject: [GIT PULL] fallout from percpu.h -> slab.h dependency breaking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Apr 2010 16:38:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

slab.h dependency breaking for uml wasn't correct and caused build
breakages under certain configurations.  Please pull from the
following branch to receive Jan Kiszka's fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git slabh

Jan Kiszka (1):
      uml: Fix build breakage after slab.h changes

 arch/um/drivers/line.c    |    1 +
 arch/um/os-Linux/helper.c |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

Thanks.

--
tejun
