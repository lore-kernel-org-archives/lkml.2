Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0GBVTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0GBVTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:19:38 -0400
Message-ID: <4C2E57DE.1000202@redhat.com>
Date: Fri, 02 Jul 2010 18:19:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: [GIT PULL for 2.6.35] Fixes for i7core/nehalem EDAC driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git for_linus

For two fixes that are needed to allow the i7core_edac driver to work with certain
systems that use non-standard bus addresses for the QPI PCI devices.

It also adds a MAINTAINERS entry for i7core_edac.

Cheers,
Mauro.

---

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git for_linus

Mauro Carvalho Chehab (3):
      i7core_edac: Properly discover the first QPI device
      i7core_edac: Avoid doing multiple probes for the same card
      MAINTAINERS: Add an entry for i7core_edac

 MAINTAINERS                |    9 ++++++-
 drivers/edac/i7core_edac.c |   53 +++++++++++++++++++++++++++++++++----------
 2 files changed, 48 insertions(+), 14 deletions(-)

