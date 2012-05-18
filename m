Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967286Ab2ERUFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:05:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967295Ab2ERUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:05:03 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 14:04:42 -0600
X-Google-Sender-Auth: LvFyDQj3ZK1ry2x9C-V-_ioAFDg
Message-ID: <CACxGe6vuA9A6X5qBt+maej2vaJCgLcHvYfqfXRGD+sKAYt4Bnw@mail.gmail.com>
Subject: [GIT PULL] GPIO build failure bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One build failure fix for GPIO needed for v3.4.  Please pull.

g.

The following changes since commit 2760f7adbb6c4e39bd3ae733f56d4ac8fb5e3521:

  gpio/exynos: Fix compiler warnings when non-exynos machines are
selected (2012-05-11 18:25:53 -0600)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to 7fd0fcff9f0d65734415fed756271c1ae2267666:

  gpio/pch: Fix build failure when selected as a module (2012-05-14
00:52:49 -0600)

----------------------------------------------------------------
GPIO build failure bug

The gpio pch9 patch merged for v3.4-rc7 has a build failure when built
as a module because it is an interrupt controller and the symbols it
needs aren't exported.  This branch restricts it to being built in to
solve the issue until it can be fixed properly in v3.5.

----------------------------------------------------------------
Grant Likely (1):
      gpio/pch: Fix build failure when selected as a module

 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
