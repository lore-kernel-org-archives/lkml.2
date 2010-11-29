Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0K2W20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:28:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:48390 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0K2W2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:28:25 -0500
Date: Tue, 30 Nov 2010 09:27:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Matthew Garrett <mjg@redhat.com>
Subject: [GIT] Fix TPM suspend regression
Message-ID: <alpine.LRH.2.00.1011300923060.26008@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this fix for a regression in the TPM code, as reported here:

http://lkml.org/lkml/2010/11/1/493
http://lkml.org/lkml/2010/11/29/219

The following changes since commit 72083646528d4887b920deb71b37e09bc7d227bb:
  Linus Torvalds (1):
        Un-inline get_pipe_info() helper function

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Matthew Garrett (1):
      tpm: Autodetect itpm devices

 drivers/char/tpm/tpm_tis.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)


-- 
James Morris
<jmorris@namei.org>
