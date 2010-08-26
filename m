Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0HZOGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:06:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34074 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0HZOGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:06:14 -0400
From: Borislav Petkov <bp@amd64.org>
To: <torvalds@linux-foundation.org>
Cc: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [GIT PULL] amd64_edac updates for 2.6.36-rc3
Date: Thu, 26 Aug 2010 16:06:27 +0200
Message-Id: <1282831589-4274-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi Linus,

please pull the following MCE reporting fixes below.

I'm sending the patches too, for reference, the respective commit
messages contain more info.

Thanks.

The following changes since commit 76be97c1fc945db08aae1f1b746012662d643e97:

  Linux 2.6.36-rc2 (2010-08-22 17:43:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (2):
      MCE, AMD: Limit MCE decoding to current families for now
      amd64_edac: Do not report error overflow as a separate error

 drivers/edac/amd64_edac.c   |   10 ----------
 drivers/edac/edac_mce_amd.c |   17 ++++++++++-------
 2 files changed, 10 insertions(+), 17 deletions(-)
