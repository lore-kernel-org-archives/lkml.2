Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab2JKKxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:53:03 -0400
Received: from tundra.namei.org ([65.99.196.166]:32946 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab2JKKxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:53:00 -0400
Date: Thu, 11 Oct 2012 21:54:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kent Yoder <key@linux.vnet.ibm.com>
Subject: [GIT] TPM bugfixes
Message-ID: <alpine.LRH.2.02.1210112153030.9640@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for the TPM code.

The following changes since commit 12250d843e8489ee00b5b7726da855e51694e792:

  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-10-11 10:27:51 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Gang Wei (1):
      driver/char/tpm: fix regression causesd by ppi

James Morris (2):
      Merge branch 'tpmdd-fixes-v3.6' of git://github.com/shpedoikal/linux into for-linus
      Merge branch 'tpmdd-next-v3.6' of git://github.com/shpedoikal/linux into for-linus

Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang

 drivers/char/tpm/tpm.c     |   24 ++++++++++++++++--------
 drivers/char/tpm/tpm.h     |    9 +++++++--
 drivers/char/tpm/tpm_ppi.c |   18 ++++++++++--------
 3 files changed, 33 insertions(+), 18 deletions(-)
