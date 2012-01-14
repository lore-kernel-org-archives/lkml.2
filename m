Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2ANF4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:56:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64763 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2ANF4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:56:12 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 13 Jan 2012 22:55:50 -0700
X-Google-Sender-Auth: zeh7a2BYLiKjc1VuOWz-ilMXtug
Message-ID: <CACxGe6s_2UUR575etRFp+R0_xx9Q1H8QMTSvbwp6YPYLvuSOoQ@mail.gmail.com>
Subject: [git pull] spi bug fix for v3.3
To: Linus Torvalds <torvalds@linux-foundation.org>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a tiny tegra spi bug fix.  Please pull.

Thanks,
g.

The following changes since commit 2145199c4f0db7c517dd788abec301dc84b91bd0:

  Merge branch 'drm-fixes' of
git://people.freedesktop.org/~airlied/linux (2012-01-13 20:48:42
-0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi-for-linus

Olof Johansson (1):
      spi/tegra: depend instead of select TEGRA_SYSTEM_DMA

 drivers/spi/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
