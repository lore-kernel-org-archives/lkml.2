Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1GOUDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 16:03:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62985 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1GOUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 16:03:30 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 15 Jul 2011 14:03:09 -0600
X-Google-Sender-Auth: dKzwRzHWMCvf6q2ES5CNnrKNXBw
Message-ID: <CACxGe6trBWBOhSyn09BwJfZwaXzqw5RkSbdisT+k8bubevLX3Q@mail.gmail.com>
Subject: [GIT PULL] gpio driver bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8d86e5f91440aa56a5df516bf58fe3883552ad56:

  Merge branch 'merge' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2011-07-12
14:21:19 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/merge

Axel Lin (1):
      gpio: wm831x: add a missing break in wm831x_gpio_dbg_show

 drivers/gpio/wm831x-gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
