Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1KRBxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 20:53:33 -0500
Received: from tundra.namei.org ([65.99.196.166]:40133 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab1KRBxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 20:53:31 -0500
Date: Fri, 18 Nov 2011 12:53:28 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem fixes
Message-ID: <alpine.LRH.2.00.1111181252440.29924@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull to your current tree.

The following changes since commit 6aaf05f472c97ebceff47d9eef464574f1a55727:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.selinuxproject.org/~jmorris/linux-security for-linus

Casey Schaufler (1):
      Smack: smackfs cipso seq read repair

James Morris (2):
      Merge branch 'for-1111' of git://gitorious.org/smack-next/kernel into for-linus
      Merge branch 'encrypted-key-fixes' of git://git.kernel.org/.../zohar/linux-integrity into for-linus

Mimi Zohar (2):
      encrypted-keys: fix error return code
      encrypted-keys: module build fixes

 security/keys/encrypted-keys/Makefile    |    8 ++-
 security/keys/encrypted-keys/encrypted.c |    2 +-
 security/keys/encrypted-keys/encrypted.h |    3 +-
 security/smack/smackfs.c                 |  115 ++++++++++--------------------
 4 files changed, 48 insertions(+), 80 deletions(-)

