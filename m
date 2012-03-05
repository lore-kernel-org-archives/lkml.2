Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab2CEXf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:35:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42342 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2CEXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:35:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.231.33 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 15:35:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial patches for 3.3-rc6
Message-ID: <20120305233525.GA18774@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tty-3.3-rc6

for you to fetch changes up to f21c6d4a49179f91fd70a41382382f08c780d425:

  tty/powerpc: early udbg consoles can't be modules (2012-02-24 16:11:50 -0800)

----------------------------------------------------------------
tty: build fix for 3.3-rc6

This contains one build fix for the powerpc udbg driver that was reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Stephen Rothwell (1):
      tty/powerpc: early udbg consoles can't be modules

 drivers/tty/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
