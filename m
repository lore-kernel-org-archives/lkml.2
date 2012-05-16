Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966700Ab2EPJhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:37:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61871 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966601Ab2EPJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:37:10 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.86.177]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 16 May 2012 12:36:49 +0300
Message-ID: <CAK=Wgbaie_Z21md-tVHJoiA57coRu7SGSmL=GCjfh8g-No6Jhg@mail.gmail.com>
Subject: [GIT PULL] remoteproc for 3.4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        "C.A, Subramaniam" <subramaniam.ca@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a tiny but quite important remoteproc fix for 3.4.

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/rproc-for-linus

for you to fetch changes up to 6fd98c124c66b0b0001bc4217392d891b1ad4a02:

  remoteproc: fix off-by-one bug in __rproc_free_vrings (2012-05-13
23:15:42 +0300)

----------------------------------------------------------------
Fix a nasty off-by-one remoteproc bug which leaks memory when
a remote processor is shut down and, on certain circumstances,
can indirectly prevent it from being reloaded.

----------------------------------------------------------------
Subramaniam Chanderashekarapuram (1):
      remoteproc: fix off-by-one bug in __rproc_free_vrings

 drivers/remoteproc/remoteproc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
