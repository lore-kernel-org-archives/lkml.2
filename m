Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab1ESRS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:18:28 -0400
Received: from service87.mimecast.com ([94.185.240.25]:44562 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933583Ab1ESRS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:18:27 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Kmemleak fixes for 2.6.40-rc1
Date: Thu, 19 May 2011 18:18:17 +0100
Message-Id: <1305825497-16225-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
X-OriginalArrivalTime: 19 May 2011 17:18:30.0077 (UTC) FILETIME=[C5E976D0:01CC1648]
X-MC-Unique: 111051918182501401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4JHIbMj010710

Hi Linus,

Could you please pull the patches below? The branch contains a few
fixes for kmemleak.

Thanks.


The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:

  Linux 2.6.39-rc5 (2011-04-26 20:48:50 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git for-linus

Catalin Marinas (3):
      kmemleak: Do not return a pointer to an object that kmemleak did not get
      kmemleak: Select DEBUG_FS unconditionally in DEBUG_KMEMLEAK
      kmemleak: Initialise kmemleak after debug_objects_mem_init()

 init/main.c       |    2 +-
 lib/Kconfig.debug |    2 +-
 mm/kmemleak.c     |    7 +++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

