Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2APUs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:48:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab2APUs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:48:26 -0500
Date: Mon, 16 Jan 2012 21:48:20 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: fernando@oss.ntt.co.jp, jason.wessel@windriver.com, mmarek@suse.cz,
        swarren@nvidia.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.3-rc1
Message-ID: <20120116204819.GA4562@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the main part of kbuild is a bit boring this time. The dtc tool got the
ability to record dependency information and kbuild makes use of it,
plus there are three minor fixes.

Michal

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Fernando Luis Vázquez Cao (1):
      scripts/genksyms: clean lex/yacc generated files

Jason Wessel (1):
      kbuild: Correctly deal with make options which contain an "s"

Michal Marek (1):
      kbuild: Fix comment in Makefile.lib

Stephen Warren (2):
      dtc: Implement -d option to write out a dependency file
      Kbuild: Use dtc's -d (dependency) option

 Makefile                      |    2 +-
 arch/arm/boot/Makefile        |    6 ++++--
 arch/microblaze/boot/Makefile |    2 +-
 arch/openrisc/boot/Makefile   |    4 ++--
 arch/powerpc/boot/Makefile    |    4 ++--
 scripts/Makefile.lib          |    8 ++++----
 scripts/dtc/dtc.c             |   21 ++++++++++++++++++++-
 scripts/dtc/srcpos.c          |    4 ++++
 scripts/dtc/srcpos.h          |    1 +
 scripts/genksyms/Makefile     |    1 +
 10 files changed, 40 insertions(+), 13 deletions(-)
