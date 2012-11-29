Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2K2IfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:35:25 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:42834 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2K2IfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:35:23 -0500
MIME-Version: 1.0
X-Originating-IP: [85.250.24.217]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 29 Nov 2012 10:35:01 +0200
Message-ID: <CAK=WgbZjufLpFevD2BJbceRGS4HQqK9fas=yakDDZ2uUcdrU-w@mail.gmail.com>
Subject: [GIT PULL] remoteproc: a single fix for 3.7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
tags/rproc-3.7-fix

for you to fetch changes up to dab55bbafdb491ce2c3f2d7136e54101e948b911:

  remoteproc: fix error path of ->find_vqs (2012-11-29 10:05:09 +0200)

----------------------------------------------------------------
A single remoteproc fix for an error path issue reported by Ido Yariv.

----------------------------------------------------------------
Ohad Ben-Cohen (1):
      remoteproc: fix error path of ->find_vqs

 drivers/remoteproc/remoteproc_virtio.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)
