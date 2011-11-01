Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab1KARXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:23:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63892 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1KARXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:23:08 -0400
Date: Tue, 1 Nov 2011 15:23:41 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2011-11-01
Message-ID: <20111101172341.GL2580@joana>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Some fixes for the 3.2 release, there are four fixes in our drivers code
by David Hermann. Szymon Janc fixed a bug that was making some dongles not
work well and a sleep in invalid context. And finally a bug fix in the mgmt
code by Johan Hedberg.

Please pull, thanks!

	Gustavo

The following changes since commit ba54238552625aad2d75f455a4d3db18ea7dec68:

  ath9k: Fix a dma warning/memory leak (2011-09-26 14:55:51 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth.git master

David Herrmann (4):
      Bluetooth: ath3k: Use GFP_KERNEL instead of GFP_ATOMIC
      Bluetooth: bcm203x: Fix race condition on disconnect
      Bluetooth: bcm203x: Use GFP_KERNEL in workqueue
      Bluetooth: bfusb: Fix error path on firmware load

Johan Hedberg (1):
      Bluetooth: Set HCI_MGMT flag only in read_controller_info

Szymon Janc (2):
      Bluetooth: rfcomm: Fix sleep in invalid context in rfcomm_security_cfm
      Bluetooth: Increase HCI reset timeout in hci_dev_do_close

 drivers/bluetooth/ath3k.c      |    4 ++--
 drivers/bluetooth/bcm203x.c    |   12 +++++++++++-
 drivers/bluetooth/bfusb.c      |   13 +++++++------
 include/net/bluetooth/rfcomm.h |    1 +
 net/bluetooth/hci_core.c       |    2 +-
 net/bluetooth/mgmt.c           |    2 --
 net/bluetooth/rfcomm/core.c    |    9 +++++++--
 7 files changed, 29 insertions(+), 14 deletions(-)
