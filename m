Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab0GWNSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:18:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52671 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0GWNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IycJptrtgnsO52suJB3CHL3oU0au+51qLCstl4QysDsf0mbekVsZ4gbup2a8l/S5ZU
         PIGp5fwWVPDTzX/cjijJ6u+9SvryqgADdZ0Mr5pA7rbTp2HVXy1zXEiBXqH9BfL/7JEU
         ne9HoTTd8uwUhpR/mrKlayxOTHwkEqPWO2ek8=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 0/5] remove custom implementation of hex_to_bin()
Date: Fri, 23 Jul 2010 16:18:05 +0300
Message-Id: <cover.1279890832.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove custom implementation of recently introduced hex_to_bin() method. All
changes related to the network subsystem in the kernel.

Andy Shevchenko (5):
  drivers: atm: don't use private copy of hex_to_bin()
  drivers: net: use newly introduced hex_to_bin()
  usb: usbnet: use newly introduced hex_to_bin()
  wireless: use newly introduced hex_to_bin()
  net: core: don't use own hex_to_bin() method

 drivers/atm/nicstar.c         |   15 ++-------------
 drivers/net/ksz884x.c         |   11 +++++------
 drivers/net/usb/usbnet.c      |   13 ++-----------
 drivers/net/wireless/ray_cs.c |   23 ++---------------------
 net/core/pktgen.c             |   36 ++++++++++++------------------------
 5 files changed, 23 insertions(+), 75 deletions(-)

