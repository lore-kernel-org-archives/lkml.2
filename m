Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2I0SFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:05:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:48918 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2I0SFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:05:03 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Thu, 27 Sep 2012 11:05:00 -0700
Message-ID: <CAOesGMhT6xBz-8h76PXuaWNrKa3EK+T2DnX9k8OcFNJONHdvJA@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC: one more bug fix for 3.6
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 23f3f0613f6172ef1f0cbb0e971adf29f1c1fe5e:

  Merge tag 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6
into fixes (2012-09-18 10:16:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 84d5dfbf09be6be71d6dda63d99a8303e85663c7:

  ARM: Orion5x: Fix too small coherent pool. (2012-09-26 16:48:47 -0700)

----------------------------------------------------------------
arm-soc: one more bug fix for 3.6

Here's a bugfix for orion5x. Without this, PCI doesn't initialize properly
because of too small coherent pool to cover the allocations needed.

A similar fix has already been done on kirkwood.

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Orion5x: Fix too small coherent pool.

 arch/arm/mach-orion5x/common.c | 7 +++++++
 1 file changed, 7 insertions(+)
