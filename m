Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1AGXE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:04:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:39478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab1AGXE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:04:27 -0500
Date: Sat, 8 Jan 2011 00:04:26 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ak@linux.intel.com, akpm@linux-foundation.org, jonas.aberg@stericsson.com,
        julia@diku.dk, u.kleine-koenig@pengutronix.de,
        xiyou.wangcong@gmail.com, yann.morin.1998@anciens.enib.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc updates for 2.6.38-rc1
Message-ID: <20110107230426.GA15371@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

remaining patches that fit nowhere else. Like with the other kbuild branches,
it's quite boring this time and it's not a lot of commits. 

Michal

The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git misc

Américo Wang (1):
      gitignore: add scripts/recordmcount

Andi Kleen (1):
      Kconfig: fix single letter command in scripts/config

Jonas Aaberg (1):
      kbuild: add numeric --set-val option to scripts/config

Julia Lawall (1):
      scripts/coccinelle: update for compatability with Coccinelle 0.2.4

Uwe Kleine-König (1):
      tags: put function prototypes back!

Yann E. MORIN (1):
      Documentation/kbuild: add info that 'choice' can have a symbol name

akpm@linux-foundation.org (2):
      headers_check: better search for functions in headers
      headers_check: Fix warning text

 Documentation/coccinelle.txt              |    4 +++
 Documentation/kbuild/kconfig-language.txt |    6 +++-
 scripts/.gitignore                        |    1 +
 scripts/coccinelle/misc/doubleinit.cocci  |    6 ++--
 scripts/coccinelle/null/deref_null.cocci  |   39 ++++++++++------------------
 scripts/config                            |   13 +++++++--
 scripts/headers_check.pl                  |    6 ++--
 scripts/tags.sh                           |    2 +-
 8 files changed, 41 insertions(+), 36 deletions(-)
