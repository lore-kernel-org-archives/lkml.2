Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2C0Txx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab2C0Txu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:53:50 -0400
Message-ID: <4F721AC9.2000301@redhat.com>
Date: Tue, 27 Mar 2012 16:53:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for 3.4-rc1] EDAC fixes
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

For a series of EDAC driver fixes. It also has one core fix at the documentation,
and a rename patch, fixing the name of the struct that contains the rank 
information.

Thanks!
Mauro

Latest commit at the branch: 
a4b4be3fd7a76021f67380b03d8bccebf067db72 edac: rename channel_info to rank_info
The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

Hui Wang (3):
      edac: sb_edac: Let the driver depend on PCI_MMCONFIG
      edac: sb_edac: Fix a INTERLEAVE_MODE() misuse
      edac: sb_edac: Fix a wrong value setting for the previous value

Mauro Carvalho Chehab (5):
      Fix sb_edac compilation with 32 bits kernels
      edac/ppc4xx_edac: Fix compilation
      edac: Improve the comments to better describe the memory concepts
      i5400_edac: Avoid calling pci_put_device() twice
      edac: rename channel_info to rank_info

Niklas Söderlund (2):
      edac: i5100 fix erroneous define for M1Err
      edac: i5100 ack error detection register after each read

 drivers/edac/Kconfig       |    2 +-
 drivers/edac/edac_mc.c     |    6 +-
 drivers/edac/i5100_edac.c  |   13 +--
 drivers/edac/i5400_edac.c  |   54 +++++++++----
 drivers/edac/ppc4xx_edac.c |    4 +-
 drivers/edac/sb_edac.c     |   52 ++++++++-----
 include/linux/edac.h       |  179 +++++++++++++++++++++++++++++++-------------
 7 files changed, 208 insertions(+), 102 deletions(-)

