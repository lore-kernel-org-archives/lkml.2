Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2LCSjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:39:08 -0500
Received: from mail.tpi.com ([70.99.223.143]:2679 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab2LCSjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:39:04 -0500
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 13:39:04 EST
Message-ID: <50BCEBCB.4080303@gmail.com>
Date: Mon, 03 Dec 2012 11:13:31 -0700
From: Tim Gardner <rtg.canonical@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: tim.gardner@canonical.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [GIT PULL] linux-firmware: cx23885: update to Version 2.06.139
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben - what is your policy on extracting firmware from Windows drivers?
It seems like it ought to be OK, and they _are_ the same files that are
covered under the license in WHENCE.

The following changes since commit bda53ca96deb3cacbef10a7a84bbaee2d09c7f34:

  brcm: new firmware version for brcmsmac (2012-12-03 14:46:28 +0000)

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/linux-firmware.git master

for you to fetch changes up to 3c592f80519a7e82eadeccfad7a5cd1604ca463c:

  cx23885: update to Version 2.06.139 (2012-12-03 11:07:43 -0700)

----------------------------------------------------------------
Tim Gardner (1):
      cx23885: update to Version 2.06.139

 v4l-cx23885-avcore-01.fw |  Bin 16382 -> 16382 bytes
 v4l-cx23885-enc.fw       |  Bin 16382 -> 376836 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)

rtg
-- 
Tim Gardner tim.gardner@canonical.com
