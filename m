Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1GPPmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 11:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1GPPmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 11:42:40 -0400
Message-ID: <4E21B169.4020902@redhat.com>
Date: Sat, 16 Jul 2011 12:42:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.0] master
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a couple of regression fixes for 3.0.

Thanks!
Mauro

The following changes since commit ddc6ff31cc22720c46c1547a5310ea260a968ae9:

  [media] msp3400: fill in v4l2_tuner based on vt->type field (2011-07-07 17:28:30 -0300)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Devin Heitmueller (1):
      [media] dvb_frontend: fix race condition in stopping/starting frontend

Jarod Wilson (2):
      [media] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
      [media] nuvoton-cir: make idle timeout more sane

Mauro Carvalho Chehab (1):
      [media] tuner-core: fix a 2.6.39 regression with mt20xx

Rafi Rubin (2):
      [media] mceusb: Timeout unit corrections
      [media] mceusb: increase default timeout to 100ms

Ralf Baechle (1):
      [media] MEDIA: Fix non-ISA_DMA_API link failure of sound code

Randy Dunlap (1):
      [media] media: fix radio-sf16fmr2 build when SND is not enabled

 drivers/media/dvb/dvb-core/dvb_frontend.c  |    8 ++++++++
 drivers/media/radio/Kconfig                |    4 ++--
 drivers/media/rc/mceusb.c                  |    9 +++++----
 drivers/media/rc/nuvoton-cir.c             |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    9 ++-------
 drivers/media/video/tuner-core.c           |   16 ++++++++++++----
 6 files changed, 30 insertions(+), 18 deletions(-)

