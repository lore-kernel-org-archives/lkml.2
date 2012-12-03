Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2LCOcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab2LCOcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:32:31 -0500
Message-ID: <50BCB7EB.6090707@redhat.com>
Date: Mon, 03 Dec 2012 12:32:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.8-final] media-fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For some driver fixes for s5p/exynos (mostly race fixes).

Thanks!
Mauro

-

The following changes since commit 86163adb8125a4ce85e0b23a50be82bd8c0daf95:

   [media] rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+ (2012-11-22 12:04:53 -0200)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to d2a0db1ee01aea154ccc460e45a16857e32c4427:

   [media] s5p-mfc: Handle multi-frame input buffer (2012-11-26 18:43:27 -0200)

----------------------------------------------------------------
Arun Kumar K (2):
       [media] s5p-mfc: Bug fix of timestamp/timecode copy mechanism
       [media] s5p-mfc: Handle multi-frame input buffer

Shaik Ameer Basha (1):
       [media] exynos-gsc: Fix settings for input and output image RGB type

Sylwester Nawrocki (5):
       [media] s5p-fimc: Prevent race conditions during subdevs registration
       [media] s5p-fimc: Don't use mutex_lock_interruptible() in device release()
       [media] fimc-lite: Don't use mutex_lock_interruptible() in device release()
       [media] exynos-gsc: Don't use mutex_lock_interruptible() in device release()
       [media] exynos-gsc: Add missing video device vfl_dir flag initialization

  drivers/media/platform/exynos-gsc/gsc-m2m.c     |  4 ++--
  drivers/media/platform/exynos-gsc/gsc-regs.h    | 16 ++++++++--------
  drivers/media/platform/s5p-fimc/fimc-capture.c  | 10 +++++++---
  drivers/media/platform/s5p-fimc/fimc-lite.c     |  6 ++++--
  drivers/media/platform/s5p-fimc/fimc-m2m.c      |  3 +--
  drivers/media/platform/s5p-fimc/fimc-mdevice.c  |  4 ++--
  drivers/media/platform/s5p-mfc/s5p_mfc.c        |  7 ++-----
  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  2 +-
  8 files changed, 27 insertions(+), 25 deletions(-)

