Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2LTW3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:29:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab2LTW3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:29:43 -0500
Date: Thu, 20 Dec 2012 23:29:41 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia.Lawall@lip6.fr, hdoyu@nvidia.com, js1304@gmail.com,
        yacine.belkadi.1@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc changes for v3.8-rc1
Message-ID: <20121220222941.GA25393@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild

* scripts/kernel-doc requires a "Return:" section for non-void functions
* ARCH=arm SUBARCH=... support for make tags
* COMPILED_SOURCE=1 support for make tags (only indexes .c files for
  which a .o exists)
* New coccinelle check
* Option parsing fix for scripts/config

Please pull for v3.8-rc1, thanks.

Michal


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Hiroshi Doyu (1):
      scripts/config: Fix wrong "shift" for --keep-case

Joonsoo Kim (2):
      scripts/tags.sh: Support subarch for ARM
      scripts/tags.sh: Support compiled source

Julia Lawall (1):
      scripts/coccinelle/misc/warn.cocci: use WARN

Yacine Belkadi (2):
      Kernel-doc: Convention: Use a "Return" section to describe return values
      scripts/kernel-doc: check that non-void fcts describe their return value

 Documentation/kernel-doc-nano-HOWTO.txt |   13 +++-
 scripts/coccinelle/misc/warn.cocci      |  109 +++++++++++++++++++++++++++++++
 scripts/config                          |    1 -
 scripts/kernel-doc                      |   34 ++++++++++
 scripts/tags.sh                         |   57 ++++++++++++++--
 5 files changed, 202 insertions(+), 12 deletions(-)
 create mode 100644 scripts/coccinelle/misc/warn.cocci
