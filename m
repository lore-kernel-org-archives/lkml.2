Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1DXGoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 02:44:30 -0400
Received: from smtp.nokia.com ([147.243.1.48]:38297 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab1DXGo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 02:44:28 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 24 Apr 2011 09:47:31 +0300
Message-Id: <20110424064731.1382.51329.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull few more UBIFS fixes. All of the fixes are about recovery from
power cuts. The fixes are small, but go with large commentaries so there are
much more insertions than deletions.

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git for-linus

Artem Bityutskiy (3):
      UBIFS: fix false space checking failure
      UBIFS: fix false assertion warning in case of I/O failures
      UBIFS: fix master node recovery

 fs/ubifs/recovery.c |   26 ++++++++++++++++++++++++++
 fs/ubifs/super.c    |   29 +++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 8 deletions(-)

Thanks,
Artem.
