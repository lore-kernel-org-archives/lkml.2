Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1AGWYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:24:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1AGWYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:24:44 -0500
Date: Fri, 7 Jan 2011 23:24:43 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jacmet@sunsite.dk, lacombar@gmail.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/kconfig updates for 2.6.38-rc1
Message-ID: <20110107222443.GA14100@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

nothing exciting in the kconfig branch either: The infamous dependency
warnings are a bit easier to read now, the rest is mostly code cleanup.

Michal

The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kconfig

Arnaud Lacombe (11):
      kconfig: the day kconfig warns about "select"-abuse has come
      kconfig: do not define AUTOCONF_INCLUDED
      kconfig: nuke second argument of conf_write_symbol()
      kbuild/nconf: fix spaces damage
      kbuild/gconf: add dummy inline for bind_textdomain_codeset()
      kconfig: fix typos
      kconfig/conf: merge duplicate switch's case
      kconfig: fix `zconfdebug' extern declaration
      kconfig: add more S_INT and S_HEX consistency checks
      kconfig: simplify select-with-unmet-direct-dependency warning
      kconfig: fix warning

Michal Marek (1):
      kconfig: Make expr_copy() take a const argument

Peter Korsgaard (1):
      nconf: handle comment entries within choice/endchoice

 Documentation/kbuild/kconfig-language.txt |    1 -
 scripts/kconfig/conf.c                    |    2 -
 scripts/kconfig/confdata.c                |   27 ++++++------------
 scripts/kconfig/expr.c                    |   44 ++++++++++++++++++++++++++++-
 scripts/kconfig/expr.h                    |    3 +-
 scripts/kconfig/lkc.h                     |    7 +++-
 scripts/kconfig/menu.c                    |   15 ++++++++--
 scripts/kconfig/nconf.c                   |   10 ++++--
 scripts/kconfig/symbol.c                  |    8 ++++-
 9 files changed, 84 insertions(+), 33 deletions(-)
