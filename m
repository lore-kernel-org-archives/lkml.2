Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2ARAMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:12:09 -0500
Received: from tundra.namei.org ([65.99.196.166]:35005 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab2ARAMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:12:07 -0500
Date: Wed, 18 Jan 2012 11:12:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Misc. security subsystem updates
Message-ID: <alpine.LRH.2.00.1201181109571.21161@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Included here are the requested changes for the new digital signature API, 
some bugfixes, and an update to the MAINTAINERS file for the git rpo.

Please pull.

The following changes since commit c2bc3a316a7281f67e36b34dac2802cbe36a9128:
  Linus Torvalds (1):
        Merge branch 'x86/rdrand' of git://git.kernel.org/.../tip/tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

David Howells (1):
      KEYS: Add missing smp_rmb() primitives to the keyring search code

Dmitry Kasatkin (5):
      lib: digital signature config option name change
      lib: digital signature dependency fix
      lib: MPILIB Kconfig description update
      lib: Removed MPILIB, MPILIB_EXTRA, and SIGNATURE prompts
      integrity: digital signature config option name change

James Morris (1):
      security: update MAINTAINERS file with new git repo

Mimi Zohar (2):
      keys: fix trusted/encrypted keys sparse rcu_assign_pointer messages
      encrypted-keys: fix rcu and sparse messages

Tetsuo Handa (1):
      TOMOYO: Accept \000 as a valid character.

 MAINTAINERS                                      |    2 +-
 include/linux/digsig.h                           |    4 ++--
 include/linux/key.h                              |    3 +++
 lib/Kconfig                                      |   19 +++++++++----------
 lib/Makefile                                     |    2 +-
 security/integrity/Kconfig                       |    4 ++--
 security/integrity/Makefile                      |    2 +-
 security/integrity/integrity.h                   |    4 ++--
 security/keys/encrypted-keys/encrypted.c         |    6 +++---
 security/keys/encrypted-keys/masterkey_trusted.c |    4 +++-
 security/keys/gc.c                               |    4 +++-
 security/keys/keyring.c                          |   22 +++++++++++++++-------
 security/keys/trusted.c                          |    4 ++--
 security/tomoyo/util.c                           |    6 +++---
 14 files changed, 50 insertions(+), 36 deletions(-)
