Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2EBU33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:29:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42772 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2EBU31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:29:27 -0400
Date: Wed, 2 May 2012 13:29:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fix for 3.4-rc5
Message-ID: <20120502202924.GA27158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.4-rc6

for you to fetch changes up to 04c235c92ce8474e9f2b358bd97f013a500385f2:

  USB: ehci-tegra: remove redundant gpio_set_value (2012-05-01 14:11:51 -0400)

----------------------------------------------------------------
USB patches for 3.4-rc5

Here are two EHCI Tegra driver patches for your tree.

The first is a bit big, but the majority is just moving code around. It
is needed due to the other EHCI core changes that went in way back in
3.4-rc1, so this driver will now properly handle suspend/resume, as it
was broken.  The other one is a minor bugfix that resolves an warning
that people have been seeing.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      EHCI: update PM methods in ehci-tegra.c

Stephen Warren (1):
      USB: ehci-tegra: remove redundant gpio_set_value

 drivers/usb/host/ehci-tegra.c |  376 +++++++++++++++++++++--------------------
 1 file changed, 195 insertions(+), 181 deletions(-)
