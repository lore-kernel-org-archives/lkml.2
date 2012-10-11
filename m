Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2JKWTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:19:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2JKWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:19:00 -0400
Date: Fri, 12 Oct 2012 00:18:42 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia.Lawall@lip6.fr, lars@metafoo.de, mail@danrl.de,
        nicolas.palix@imag.fr, rdunlap@xenotime.net, tkhai@yandex.ru,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.7
Message-ID: <20121011221841.GA7717@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

in the non-critical part of kbuild, I have
* Some make coccicheck improvements and two new tests
* Support for a cleaner html output in scripts/kernel-doc, named html5
  (no, it does not play videos, yet)

BTW, Randy wants to route further kernel-doc patches through the kbuild
tree.

Thanks,
Michal

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

for you to fetch changes up to 26de9c26bf8557584c1977da92f3ed1b752291cf:

  Update SmPL/Coccinelle section of MAINTAINERS (2012-10-11 15:20:03 +0200)

----------------------------------------------------------------
Dan Luedtke (1):
      scripts/kernel-doc: added support for html5

Julia Lawall (1):
      scripts/coccinelle/tests/odd_ptr_err.cocci: semantic patch for IS_ERR/PTR_ERR inconsistency

Kirill Tkhai (1):
      scripts/tags.sh: Add magic for pci access functions

Lars-Peter Clausen (1):
      scripts/coccinelle: ptr_ret: Add ternary operator version

Nicolas Palix (2):
      coccicheck: Add the rep+ctxt mode
      Update SmPL/Coccinelle section of MAINTAINERS

Randy Dunlap (1):
      scripts/kernel-doc: drop maintainer

 MAINTAINERS                                |   11 +-
 scripts/coccicheck                         |    3 +
 scripts/coccinelle/api/ptr_ret.cocci       |   26 +++
 scripts/coccinelle/tests/odd_ptr_err.cocci |   65 +++++++
 scripts/kernel-doc                         |  273 +++++++++++++++++++++++++++-
 scripts/tags.sh                            |    8 +-
 6 files changed, 369 insertions(+), 17 deletions(-)
 create mode 100644 scripts/coccinelle/tests/odd_ptr_err.cocci
