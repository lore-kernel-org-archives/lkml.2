Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1CSJOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 05:14:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1CSJOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:14:47 -0400
Date: Sat, 19 Mar 2011 10:14:45 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dick@streefland.net, kjbmail@gmail.com, mcrowe@zipitwireless.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc updates for v2.6.39-rc1
Message-ID: <20110319091445.GA19609@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

fits-nowhere-else branch:
* scripts/extract-ikconfig support for kernels compressed with xz
* make gtags to generate index for GNU GLOBAL
* scripts/setlocalversion update for mercurial (hm, this should have
  gone through the kbuild branch actually).

Please pull.

Thanks,
Michal

The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git misc

Dick Streefland (1):
      scripts/extract-ikconfig: add xz compression support

Jianbin Kang (1):
      kbuild: add GNU GLOBAL tags generation

Mike Crowe (1):
      setlocalversion: update mercurial tag parsing

 Makefile                 |    7 ++++---
 scripts/extract-ikconfig |    9 +++++----
 scripts/setlocalversion  |   14 +++++++++-----
 scripts/tags.sh          |    9 +++++++++
 4 files changed, 27 insertions(+), 12 deletions(-)
