Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2ASVrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:47:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35177 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2ASVrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:47:07 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 19 Jan 2012 14:46:45 -0700
X-Google-Sender-Auth: RHmiShbgaFBeF7uuJRREjgp13Lk
Message-ID: <CACxGe6uSO-S1Mxk8ocfH_xeNvZKb9ad=dvakVoAg5_Avtxko=w@mail.gmail.com>
Subject: [git pull] minor GPIO bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.  Nothing exciting here.  Please pull.

Thanks,
g.

The following changes since commit 90a4c0f51e8e44111a926be6f4c87af3938a79c3:

  uml: fix compile for x86-64 (2012-01-18 19:26:11 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio-for-linus

Grant Likely (1):
      gpio/it8761e: Restrict it8761e gpio driver to x86.

Laxman Dewangan (1):
      gpio: tps65910: Use correct offset for gpio initialization

Márton Németh (4):
      gpio-pch: cleanup NULL pointer checking
      gpio-pch: cleanup __iomem annotation usage
      gpio-ml-ioh: cleanup NULL pointer checking
      gpio-ml-ioh: cleanup __iomem annotation usage

 drivers/gpio/Kconfig         |    1 +
 drivers/gpio/gpio-ml-ioh.c   |    8 ++++----
 drivers/gpio/gpio-pch.c      |    4 ++--
 drivers/gpio/gpio-tps65910.c |    2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
