Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab1KCQHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:07:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1KCQHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:07:07 -0400
Date: Thu, 3 Nov 2011 17:07:06 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: corentincj@iksaif.net, imunsie@au1.ibm.com, lacombar@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/misc for 3.2
Message-ID: <20111103160706.GA8180@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the non-critical part of kbuild for 3.2
- a new checkpatch.pl check for Makefile to use proper variables
- make tags fix for powerpc
- new extract-vmlinux script to extract vmlinux from a vmlinuz boot image

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git misc

Arnaud Lacombe (1):
      script/checkpatch.pl: warn about deprecated use of EXTRA_{A,C,CPP,LD}FLAGS

Corentin Chary (1):
      scripts: add extract-vmlinux

Ian Munsie (1):
      tags, powerpc: Update tags.sh to support _GLOBAL symbols

 scripts/checkpatch.pl   |   14 ++++++++++
 scripts/extract-vmlinux |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 scripts/tags.sh         |    4 +-
 3 files changed, 78 insertions(+), 2 deletions(-)
 create mode 100755 scripts/extract-vmlinux
