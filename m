Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2E1Mh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:37:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2E1MhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:37:25 -0400
Date: Mon, 28 May 2012 14:37:23 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiederm@xmission.com, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig for 3.5-rc1
Message-ID: <20120528123723.GA14538@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The kconfig part of kbuild for 3.5 includes:
* Error handling for make KCONFIG_ALLCONFIG=<...> all*config plus a fix
  for a bug that was exposed by this
* Fix for the script/config utility.

Michal

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kconfig

for you to fetch changes up to d6686da814c884e341d3bd8aa54947c91cb678be:

  scripts/config: properly report and set string options (2012-05-16 00:13:11 +0200)

----------------------------------------------------------------
Eric W. Biederman (2):
      kconfig: Add error handling to KCONFIG_ALLCONFIG
      kbuild: all{no,yes,mod,def,rand}config only read files when instructed to.

Yann E. MORIN (1):
      scripts/config: properly report and set string options

 Documentation/kbuild/kconfig.txt |   18 +++++++++---------
 scripts/config                   |   11 +++++++----
 scripts/kconfig/conf.c           |   22 ++++++++++++++++------
 3 files changed, 32 insertions(+), 19 deletions(-)
