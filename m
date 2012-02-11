Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2BKDPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 22:15:10 -0500
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:51523
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2BKDPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 22:15:08 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Feb 2012 22:15:08 EST
Message-ID: <4F35DB79.6070104@chelsio.com>
Date: Fri, 10 Feb 2012 19:07:37 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com
Subject: pull request: linux-firmware: update cxgb* firmwares
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Can you please pull from the following URL?
      git://git.chelsio.net/pub/git/linux-firmware.git for-david

It contains the following commits:
03cadf2 linux-firmware: update cxgb3 driver firmware to revision 7.12.0
235dfaf linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
e2ea873 linux-firmware: remove current t4fw.bin

The following changes since commit 15888a2eab052ac3d3f49334e4f6f05f347a516e:

   bnx2x: Adding FW 7.0.29.0 (2011-10-24 16:31:44 +0200)

are available in the git repository at:
   git://git.chelsio.net/pub/git/linux-firmware.git for-david

Divy Le Ray (3):
       linux-firmware: remove current t4fw.bin
       linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
       linux-firmware: update cxgb3 driver firmware to revision 7.12.0

  WHENCE                  |    3 ++-
  cxgb3/t3fw-7.12.0.bin   |  Bin 0 ->  31812 bytes
  cxgb4/t4fw-1.4.16.0.bin |  Bin 0 ->  298496 bytes
  cxgb4/t4fw.bin          |  Bin 241664 ->  0 bytes
  4 files changed, 2 insertions(+), 1 deletions(-)
  create mode 100755 cxgb3/t3fw-7.12.0.bin
  create mode 100644 cxgb4/t4fw-1.4.16.0.bin
  delete mode 100644 cxgb4/t4fw.bin


Cheers,
Divy



