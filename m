Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1AXAuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 19:50:50 -0500
Received: from tundra.namei.org ([65.99.196.166]:60265 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1AXAut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 19:50:49 -0500
Date: Mon, 24 Jan 2011 11:50:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 2.6.38
Message-ID: <alpine.LRH.2.00.1101241147580.31034@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.

This is another round of updates, with a few bugfixes, filename 
changes in the new trusted & encryptped keys code as requested by 
dhowells, and a maintainers entry for that.


The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:
  Linus Torvalds (1):
        Linux 2.6.38-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Davidlohr Bueso (1):
      selinux: return -ENOMEM when memory allocation fails

Jesper Juhl (1):
      trusted keys: Fix a memory leak in trusted_update().

Mimi Zohar (3):
      trusted-keys: rename trusted_defined files to trusted
      encrypted-keys: rename encrypted_defined files to encrypted
      keys: add trusted and encrypted maintainers

Olof Johansson (1):
      tpm: fix panic caused by "tpm: Autodetect itpm devices"

Rajiv Andrade (1):
      TPM: Long default timeout fix

 MAINTAINERS                                        |   22 ++++++++++++++++++++
 drivers/char/tpm/tpm.c                             |   10 +++++---
 drivers/char/tpm/tpm_tis.c                         |    6 ++--
 security/keys/Makefile                             |    4 +-
 security/keys/{encrypted_defined.c => encrypted.c} |    3 +-
 security/keys/{encrypted_defined.h => encrypted.h} |    0
 security/keys/{trusted_defined.c => trusted.c}     |    3 +-
 security/keys/{trusted_defined.h => trusted.h}     |    0
 security/selinux/ss/conditional.c                  |    2 +-
 security/selinux/ss/policydb.c                     |    4 +-
 10 files changed, 40 insertions(+), 14 deletions(-)
 rename security/keys/{encrypted_defined.c => encrypted.c} (99%)
 rename security/keys/{encrypted_defined.h => encrypted.h} (100%)
 rename security/keys/{trusted_defined.c => trusted.c} (99%)
 rename security/keys/{trusted_defined.h => trusted.h} (100%)

-- 
James Morris
<jmorris@namei.org>
