Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2BPHTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 02:19:20 -0500
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:38076
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2BPHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 02:19:19 -0500
Message-ID: <4F3CADB7.1030802@chelsio.com>
Date: Wed, 15 Feb 2012 23:18:15 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: pull request: linux-firmware: update cxgb* firmwares
References: <4F35DB79.6070104@chelsio.com> <20120211140701.GA5194@neilslaptop.think-freely.org> <4F38A526.70900@chelsio.com>
In-Reply-To: <4F38A526.70900@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, David,

I just realize that the rules to submit patches or pull requests to 
linux-firmware have changed recently.
I had posted a pull request last week against David's tree 
(https://lkml.org/lkml/2012/2/13/27).
I am now re-posting the pull request against the official tree.

Can you please pull from the following URL?
        git://git.chelsio.net/pub/git/linux-firmware.git for-upstream


It contains the following commits:
07af67c linux-firmware: update cxgb3 driver firmware to revision 7.12.0
196909a linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
3b460f1 linux-firmware: rename t4fw.bin

The following changes since commit 38118a598df73d5a9fd72bf04910e8298db82a46:

   linux-firmware: brcm: add firmware for bcm43236 usb device 
(2012-02-11 19:20:10 +0000)

are available in the git repository at:
   git://git.chelsio.net/pub/git/linux-firmware for-upstream

Divy Le Ray (3):
       linux-firmware: rename t4fw.bin
       linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
       linux-firmware: update cxgb3 driver firmware to revision 7.12.0

  WHENCE                  |    4 +++-
  cxgb3/t3fw-7.12.0.bin   |  Bin 0 -> 31812 bytes
  cxgb4/t4fw-1.3.10.0.bin |  Bin 0 -> 241664 bytes
  cxgb4/t4fw-1.4.16.0.bin |  Bin 0 -> 298496 bytes
  cxgb4/t4fw.bin          |  Bin 241664 -> 17 bytes
  5 files changed, 3 insertions(+), 1 deletions(-)
  create mode 100755 cxgb3/t3fw-7.12.0.bin
  create mode 100644 cxgb4/t4fw-1.3.10.0.bin
  create mode 100644 cxgb4/t4fw-1.4.16.0.bin
  mode change 100644 => 120000 cxgb4/t4fw.bin

Cheers,
Divy

