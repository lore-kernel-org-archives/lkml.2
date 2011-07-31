Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1GaFuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:50:46 -0400
Received: from lunge.queued.net ([173.255.254.236]:52139 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1GaFum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:50:42 -0400
Date: Sat, 30 Jul 2011 22:50:39 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dsd@laptop.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        dcbw@redhat.com, libertas-dev@lists.infradead.org
Subject: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
Message-ID: <20110730225039.34467e4e@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 13f5008494268031d569f830d0955479bd5b9dfc:

  Merge git://anongit.freedesktop.org/~dcbw/linux-firmware (2011-07-31 00:15:37 +0100)

are available in the git repository at:

  git://lunge.queued.net/git/linux-firmware master

Andres Salomon (1):
      libertas: add OLPC libertas blobs

 LICENCE.OLPC            |   33 +++++++++++++++++++++++++++++++++
 WHENCE                  |   18 +++++++++++++++++-
 libertas/lbtf_sdio.bin  |  Bin 0 -> 120924 bytes
 libertas/lbtf_usb.bin   |  Bin 0 -> 118888 bytes
 libertas/usb8388_v5.bin |  Bin 100292 -> 127824 bytes
 5 files changed, 50 insertions(+), 1 deletions(-)
 create mode 100644 LICENCE.OLPC
 create mode 100644 libertas/lbtf_sdio.bin
 create mode 100644 libertas/lbtf_usb.bin
