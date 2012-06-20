Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2FTRav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:30:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526Ab2FTRas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:30:48 -0400
Date: Wed, 20 Jun 2012 10:30:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/20] 3.0.36-stable review
Message-ID: <20120620173044.GA6910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.36 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun 22 17:30:38 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.36-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                          |    4 +-
 arch/arm/mach-imx/mach-mx21ads.c  |    2 +-
 arch/x86/xen/enlighten.c          |    8 ++++
 drivers/pci/pci.c                 |    5 ++
 drivers/pci/quirks.c              |   26 ++++++++++
 drivers/usb/class/cdc-acm.c       |    8 ++++
 drivers/usb/core/hcd-pci.c        |    9 ----
 drivers/usb/core/message.c        |    3 +-
 drivers/usb/host/ehci-pci.c       |    8 ----
 drivers/usb/host/xhci.c           |    8 ++--
 drivers/usb/serial/cp210x.c       |    1 +
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 drivers/usb/serial/mct_u232.c     |   13 +++--
 drivers/usb/serial/mos7840.c      |    2 +-
 drivers/usb/serial/option.c       |   96 ++++++++++++++++++-------------------
 drivers/usb/serial/qcserial.c     |    6 +++
 drivers/usb/serial/sierra.c       |    4 ++
 drivers/usb/serial/usb-serial.c   |    6 ++-
 fs/hfsplus/wrapper.c              |    2 +-
 include/linux/pci.h               |    2 +
 include/linux/usb/hcd.h           |    2 -
 net/sunrpc/svc.c                  |    3 +-
 23 files changed, 134 insertions(+), 86 deletions(-)

