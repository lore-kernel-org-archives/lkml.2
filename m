Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2G3KlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:41:07 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:47053 "EHLO linux.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752668Ab2G3KlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:41:05 -0400
Date: Mon, 30 Jul 2012 12:41:02 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia.Lawall@lip6.fr, lars@metafoo.de, max@stro.at, namhyung.kim@lge.com,
        yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.6-rc1
Message-ID: <20120730104102.GA1465@noe.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild for v3.6-rc1:

* Two new coccinelle semantic patches
* New scripts/tags.sh regexp
* scripts/config improvements that I mistakenly applied here instead of
  in the kconfig branch (but there are no conflicts)
* Debian packaging fixes

Thanks,
Michal


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Julia Lawall (1):
      scripts/coccinelle: list iterator variable semantic patch

Lars-Peter Clausen (1):
      scripts/coccinelle: Find threaded IRQs requests which are missing IRQF_ONESHOT

Namhyung Kim (1):
      scripts/tags.sh: Teach [ce]tags about libtraceeevent error codes

Yann E. MORIN (3):
      scripts/config: add option to not upper-case symbols
      scripts/config: allow alternate prefix to config option symbol
      scripts/config: add option to undef a symbol

maximilian attems (2):
      deb-pkg: Install linux-firmware-image in versioned dir
      deb-pkg: Add all Makefiles to header package

 scripts/coccinelle/iterators/use_after_iter.cocci |  147 +++++++++++++++++++++
 scripts/coccinelle/misc/irqf_oneshot.cocci        |   65 +++++++++
 scripts/config                                    |   60 ++++++---
 scripts/package/builddeb                          |    7 +-
 scripts/tags.sh                                   |    6 +-
 5 files changed, 264 insertions(+), 21 deletions(-)
 create mode 100644 scripts/coccinelle/iterators/use_after_iter.cocci
 create mode 100644 scripts/coccinelle/misc/irqf_oneshot.cocci
