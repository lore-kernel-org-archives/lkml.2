Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1ATT7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:59:36 -0500
Received: from claw.goop.org ([74.207.240.146]:37868 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab1ATT7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:59:34 -0500
Message-ID: <4D38941F.9070101@goop.org>
Date: Thu, 20 Jan 2011 11:59:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [GIT PULL] xen: xenbus driver fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a handful of little bugfixes for the xenbus driver which were
overlooked in the last merge window.  They've been floating around in
linux-next and xen.git master for ages.

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/xenbus

Daniel De Graaf (3):
      xenbus: add missing wakeup in concurrent read/write
      xenbus: avoid zero returns from read()
      xenbus: Fix memory leak on release

Diego Ongaro (1):
      xenbus: allow any xenbus command over /proc/xen/xenbus

Jeremy Fitzhardinge (1):
      xenfs/xenbus: report partial reads/writes correctly

 drivers/xen/xenfs/xenbus.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

Thanks,
	J

