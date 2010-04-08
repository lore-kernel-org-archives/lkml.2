Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab0DHPw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:52:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab0DHPw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:52:56 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL IBFT] iBFT update for 2.6.34-rc3
Date: Thu,  8 Apr 2010 15:52:15 +0000
Message-Id: <1270741936-1306-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 15:52:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull the following change since commit: 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
Linus Torvalds (1):
    Linux 2.6.34-rc3

which is available in the git repository at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git ibft-fixes

Yinghai Lu (1):
      ibft, x86: Change reserve_ibft_region() to find_ibft_region()

 arch/x86/kernel/setup.c            |   14 ++++++++++++--
 drivers/firmware/iscsi_ibft_find.c |   11 ++++++++---
 include/linux/iscsi_ibft.h         |    8 ++++++--
 3 files changed, 26 insertions(+), 7 deletions(-)

