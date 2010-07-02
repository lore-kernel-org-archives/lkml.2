Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab0GBV7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:59:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39857 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886Ab0GBV7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:59:48 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 2 Jul 2010 15:59:27 -0600
X-Google-Sender-Auth: lwdKCLIzvB_wvtKaAz7apfMzWeM
Message-ID: <AANLkTimcP0H1aLdGiLk-j1No5DuLwJIKKiWm_CJ01_gR@mail.gmail.com>
Subject: [git pull] one OF-related build regression fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.  One build fix for 2.6.35 committed to my tree.

g.


The following changes since commit 123f94f22e3d283dfe68742b269c245b0501ad82:
  Linus Torvalds (1):
        Merge branch 'sched-fixes-for-linus' of
git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge-devicetree

Dan Williams (1):
      of/dma: fix build breakage in ppc4xx adma driver

 drivers/dma/ppc4xx/adma.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
