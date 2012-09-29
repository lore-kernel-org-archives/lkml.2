Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab2I2CDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 22:03:42 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:38601
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754780Ab2I2CDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 22:03:40 -0400
X-Greylist: delayed 1964 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 22:03:40 EDT
Date: Fri, 28 Sep 2012 18:30:29 -0700
From: Divy Le Ray <divy@chelsio.com>
To: Ben Hutchings <ben@decadent.org.uk>, David Woodhouse <dwmw2@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Subject: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20120928183029.41d151b6@zola.asicdesigners.com>
Organization: Chelsio Communications
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please pull from the following URL?
    git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

The following changes since commit 236367db10f1e618a3ced2538f5cd1802c31ebd8:
  Yuval Mintz (1):
       bnx2x: update fw to 7.8.2

are available in the git repository at: 
 git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

Divy Le Ray (1):
     cxgb4: update firmware to revision 1.6.2.0

 WHENCE                  |    2 +-
 cxgb4/t4fw-1.4.23.0.bin |  Bin 326144 -> 0 bytes
 cxgb4/t4fw-1.6.2.0.bin  |  Bin 0 -> 431616 bytes
 cxgb4/t4fw.bin          |    2 +-
 4 files changed, 2 insertions(+), 2 deletions(-)
 delete mode 100644 cxgb4/t4fw-1.4.23.0.bin
 create mode 100644 cxgb4/t4fw-1.6.2.0.bin

Cheers,
Divy
