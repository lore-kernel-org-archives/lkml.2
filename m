Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2GHTXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:23:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49653 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2GHTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:23:52 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.10.162]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 8 Jul 2012 22:23:32 +0300
Message-ID: <CAK=WgbbvHobMODDaa+k10uWfbMaH-6SZ6o9f6Vx+aB2TSvfDQw@mail.gmail.com>
Subject: [GIT PULL] rpmsg fixes for 3.5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git
tags/rpmsg-3.5-fixes

for you to fetch changes up to 15fd943af50dbc5f7f4de33835795c72595f7bf4:

  rpmsg: make sure inflight messages don't invoke just-removed
callbacks (2012-07-04 11:51:59 +0300)

----------------------------------------------------------------
Fixing two (somewhat rare) endpoint-related race issues, both of which
were reported by Fernando Guzman Lugo.

----------------------------------------------------------------
Ohad Ben-Cohen (2):
      rpmsg: avoid premature deallocation of endpoints
      rpmsg: make sure inflight messages don't invoke just-removed callbacks

 drivers/rpmsg/virtio_rpmsg_bus.c | 55 ++++++++++++++++++++++++++++++++++++----
 include/linux/rpmsg.h            |  6 +++++
 2 files changed, 56 insertions(+), 5 deletions(-)
