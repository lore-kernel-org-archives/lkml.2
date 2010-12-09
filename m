Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0LIQk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:40:59 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62175 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0LIQk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:40:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Xh14/40nF7yZapiF6peQqM5V9eGs3ZmReURbi3dzcZ3tIVl/9uqhP5lpJ7SIEBH1SV
         xPLPBsxXNzkBeBqQrAQSwCga4BJbwcSH2fB7brFx9ZHzUUO80y8phb+U6wq3bDbQcZvE
         5t0gzfooZg9cF5o0ywo/0TLO6zkibtNeS1RHQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Staging: use DEFINE_PCI_DEVICE_TABLE when possible
Date: Fri, 10 Dec 2010 01:40:24 +0900
Message-Id: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset tries to convert open-coded struct pci_device_id tables
to preferred form of DEFINE_PCI_DEVICE_TABLE. As a result it will make
the tables const and marks as __devinitconst.

Being conservative, I only convert the tables already declared as const
but it could be applied to others too. I'll prepare another series for
those if this looks good to you.

Thanks.

---
Only compile-tested!

Namhyung Kim (6):
  Staging: sm7xx: use DEFINE_PCI_DEVICE_TABLE
  Staging: cx25821: use DEFINE_PCI_DEVICE_TABLE
  Staging: rtl8192e: use DEFINE_PCI_DEVICE_TABLE
  Staging: phison: use DEFINE_PCI_DEVICE_TABLE
  Staging: vme_tsi148: use DEFINE_PCI_DEVICE_TABLE
  Staging: vme_ca91cx42: use DEFINE_PCI_DEVICE_TABLE

 drivers/staging/cx25821/cx25821-alsa.c     |    2 +-
 drivers/staging/phison/phison.c            |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c     |    2 +-
 drivers/staging/sm7xx/smtcfb.c             |    2 +-
 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.7.3.3.400.g93cef

