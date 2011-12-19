Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1LSPmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:42:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1LSPmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:42:14 -0500
Message-ID: <4EEF5B47.2060506@redhat.com>
Date: Mon, 19 Dec 2011 13:41:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL for 3.2-rc5] media fixes
References: <4EE63039.4040004@redhat.com>
In-Reply-To: <4EE63039.4040004@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-2011 14:47, Mauro Carvalho Chehab wrote:
> Hi Linus,
> 
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> For a couple fixes for media drivers.
> The changes are:
>     - ati_remote (new driver for 3.2): Fix the scancode tables;
>     - af9015: fix some issues with firmware load;
>     - au0828: (trivial) add device ID's for some devices;
>     - omap3 and s5p: several small fixes;
>     - Update MAINTAINERS entry to cover /drivers/staging/media and
>       media DocBook;
>     - a few other small trivial fixes.
> 
> Thanks!
> Mauro
> 

Hi Linus,

Due to Antti's afraid of breaking something, I've added a new patch
to this tree reverting his original one.

So, this patch series have:
     - ati_remote (new driver for 3.2): Fix the scancode tables;
     - au0828: (trivial) add device ID's for some devices;
     - omap3 and s5p: several small fixes;
     - Update MAINTAINERS entry to cover /drivers/staging/media and
       media DocBook;
     - a few other small trivial fixes.

Unfortunately, I had a very busy time last week, working every day 
from 9 to 24h, and then I had to drive for about 12h at the weekend, 
due to Xmas/New Year's celebrations. So, I failed to add the extra
"revert" patch to linux-next. The other patches are there at -next
since 7 days ago.

So, please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Thanks!
Mauro

-

Latest commit at the branch: 
4b5d8da88e3fab76700e89488a8c65c54facb9a3 Revert "[media] af9015: limit I2C access to keep FW happy"
The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Anssi Hannula (1):
      [media] ati_remote: switch to single-byte scancodes

Antti Palosaari (3):
      [media] af9015: limit I2C access to keep FW happy
      [media] tda18218: fix 6 MHz default IF frequency
      [media] mxl5007t: fix reg read

Dan Carpenter (1):
      [media] V4L: mt9t112: use after free in mt9t112_probe()

Dmitry Artamonow (1):
      [media] omap3isp: fix compilation of ispvideo.c

Gary Thomas (1):
      [media] omap_vout: Fix compile error in 3.1

Guennadi Liakhovetski (2):
      [media] V4L: soc-camera: fix compiler warnings on 64-bit platforms
      [media] V4L: mt9m111: fix uninitialised mutex

Janusz Krzysztofik (1):
      [media] V4L: omap1_camera: fix missing <linux/module.h> include

Joe Perches (1):
      [media] [trivial] omap24xxcam-dma: Fix logical test

Marek Szyprowski (1):
      [media] media: video: s5p-tv: fix build break

Mauro Carvalho Chehab (2):
      MAINTAINERS: Update media entries
      Revert "[media] af9015: limit I2C access to keep FW happy"

Michael Krufky (3):
      [media] au0828: add missing USB ID 2040:7260
      [media] au0828: add missing USB ID 2040:7213
      [media] au0828: add missing models 72101, 72201 & 72261 to the model matrix

Peter Korsgaard (1):
      [media] s5p_mfc_enc: fix s/H264/H263/ typo

Randy Dunlap (1):
      [media] media/staging: fix allyesconfig build error

Sylwester Nawrocki (10):
      [media] s5p-fimc: Fix wrong pointer dereference when unregistering sensors
      [media] s5p-fimc: Fix error in the capture subdev deinitialization
      [media] s5p-fimc: Fix initialization for proper system suspend support
      [media] s5p-fimc: Fix buffer dequeue order issue
      [media] s5p-fimc: Allow probe() to succeed with null platform data
      [media] s5p-fimc: Adjust pixel height alignments according to the IP revision
      [media] s5p-fimc: Fail driver probing when sensor configuration is wrong
      [media] s5p-fimc: Use correct fourcc for RGB565 colour format
      [media] m5mols: Fix set_fmt to return proper pixel format code
      [media] s5p-fimc: Fix camera input configuration in subdev operations

Thomas Jarosch (1):
      [media] m5mols: Fix logic in sanity check

Tomi Valkeinen (1):
      [media] omap_vout: fix crash if no driver for a display

 MAINTAINERS                                      |    2 +
 drivers/media/common/tuners/mxl5007t.c           |    3 +-
 drivers/media/common/tuners/tda18218.c           |    2 +-
 drivers/media/rc/ati_remote.c                    |  111 +++++++++----------
 drivers/media/rc/keymaps/rc-ati-x10.c            |   96 ++++++++--------
 drivers/media/rc/keymaps/rc-medion-x10.c         |  128 +++++++++++-----------
 drivers/media/rc/keymaps/rc-snapstream-firefly.c |  114 ++++++++++----------
 drivers/media/video/au0828/au0828-cards.c        |    7 +
 drivers/media/video/m5mols/m5mols.h              |    2 -
 drivers/media/video/m5mols/m5mols_core.c         |   22 ++--
 drivers/media/video/mt9m111.c                    |    1 +
 drivers/media/video/mt9t112.c                    |    4 +-
 drivers/media/video/omap/omap_vout.c             |    9 ++
 drivers/media/video/omap1_camera.c               |    1 +
 drivers/media/video/omap24xxcam-dma.c            |    2 +-
 drivers/media/video/omap3isp/ispvideo.c          |    1 +
 drivers/media/video/ov6650.c                     |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c      |   14 ++-
 drivers/media/video/s5p-fimc/fimc-core.c         |   24 ++--
 drivers/media/video/s5p-fimc/fimc-core.h         |    2 +
 drivers/media/video/s5p-fimc/fimc-mdevice.c      |   43 +++++---
 drivers/media/video/s5p-fimc/fimc-reg.c          |   15 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c        |    2 +-
 drivers/media/video/s5p-tv/mixer_video.c         |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c       |   34 ++++--
 drivers/media/video/sh_mobile_csi2.c             |    4 +-
 drivers/media/video/soc_camera.c                 |    3 +-
 drivers/staging/media/as102/as102_drv.c          |    4 +-
 drivers/staging/media/as102/as102_drv.h          |    3 +-
 include/media/soc_camera.h                       |    7 +-
 30 files changed, 357 insertions(+), 306 deletions(-)
