Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923Ab1FSEiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 00:38:21 -0400
Received: from lunge.queued.net ([66.23.231.200]:38159 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1FSEiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 00:38:19 -0400
Date: Sat, 18 Jun 2011 21:38:03 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dsd@laptop.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        dcbw@redhat.com, libertas-dev@lists.infradead.org
Subject: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Message-ID: <20110618213803.521db1b3@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 97649b1e5449029c845ebf7500e780a8867c3e89:

  linux-firmware: Add a new FW 7.0.20.0 (2011-06-15 11:38:11 +0100)

are available in the git repository at:
  git://lunge.queued.net/git/linux-firmware master

Andres Salomon (1):
      libertas: add OLPC libertas blobs

 LICENCE.OLPC                 |   33 +++++++++++++++++++++++++++++++++
 WHENCE                       |   20 ++++++++++++++++++++
 libertas/lbtf_sdio.bin       |  Bin 0 -> 120924 bytes
 libertas/lbtf_usb.bin        |  Bin 0 -> 118888 bytes
 libertas/sd8686_v9_OLPC.bin  |  Bin 0 -> 124244 bytes
 libertas/usb8388_v5_OLPC.bin |  Bin 0 -> 127824 bytes
 6 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 LICENCE.OLPC
 create mode 100644 libertas/lbtf_sdio.bin
 create mode 100644 libertas/lbtf_usb.bin
 create mode 100644 libertas/sd8686_v9_OLPC.bin
 create mode 100644 libertas/usb8388_v5_OLPC.bin
