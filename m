Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2LTV7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:59:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2LTV7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:59:12 -0500
Date: Thu, 20 Dec 2012 22:59:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: andreas@biessmann.de, ckeepax@opensource.wolfsonmicro.com,
        pawel.moll@arm.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.8-rc1
Message-ID: <20121220215909.GA24643@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

the kbuild changes are minimal this time:
* scripts/pnmlogo fix for some newer format
* minor top-level Makefile cleanup
* fix for a v3.5 regression with make clean M=<directory>

Please pull for v3.8-rc1, thanks.

Michal

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Andreas Bieﬂmann (1):
      scripts/pnmtologo: fix for plain PBM

Charles Keepax (1):
      kbuild: Remove reference to uninitialised variable

Pawel Moll (1):
      kbuild: Do not remove vmlinux when cleaning external module

 Makefile            |   10 ++++++----
 scripts/pnmtologo.c |    7 +++++++
 2 files changed, 13 insertions(+), 4 deletions(-)
