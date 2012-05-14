Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2ENLQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab2ENLQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:16:38 -0400
Message-ID: <4FB0E992.2070402@redhat.com>
Date: Mon, 14 May 2012 08:16:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.4-final] media fixes
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a some fix patches for v3.4, including a regression fix at DVB core.

Thanks!
Mauro

-

Latest commit at the branch: 
788ab1bb03d304232711b6ca9718534f588ee9fc [media] gspca - sonixj: Fix a zero divide in isoc interrupt
The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Dan Carpenter (1):
      [media] fintek-cir: change || to &&

Guennadi Liakhovetski (1):
      [media] V4L: soc-camera: protect hosts during probing from overzealous user-space

H Hartley Sweeten (2):
      [media] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer
      [media] media: videobuf2-dma-contig: include header for exported symbols

Jean-François Moine (1):
      [media] gspca - sonixj: Fix a zero divide in isoc interrupt

Jonathan Corbet (1):
      [media] marvell-cam: fix an ARM build error

Laurent Pinchart (1):
      [media] media: vb2-memops: Export vb2_get_vma symbol

Luis Henriques (1):
      [media] rc: Postpone ISR registration

Mauro Carvalho Chehab (1):
      [media] dvb_frontend: fix a regression with DVB-S zig-zag

Sylwester Nawrocki (3):
      [media] V4L: Schedule V4L2_CID_HCENTER, V4L2_CID_VCENTER controls for removal
      [media] s5p-fimc: Fix locking in subdev set_crop op
      [media] s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS

 Documentation/feature-removal-schedule.txt    |   10 +++
 drivers/media/dvb/dvb-core/dvb_frontend.c     |    4 +
 drivers/media/rc/ene_ir.c                     |   32 +++++-----
 drivers/media/rc/fintek-cir.c                 |   22 ++++----
 drivers/media/rc/ite-cir.c                    |   20 +++---
 drivers/media/rc/nuvoton-cir.c                |   36 ++++++------
 drivers/media/rc/winbond-cir.c                |   78 ++++++++++++------------
 drivers/media/video/gspca/sonixj.c            |    8 +-
 drivers/media/video/marvell-ccic/mmp-driver.c |    1 -
 drivers/media/video/s5p-fimc/fimc-capture.c   |   33 +++++++----
 drivers/media/video/s5p-fimc/fimc-core.c      |    4 +-
 drivers/media/video/s5p-fimc/fimc-core.h      |    2 +-
 drivers/media/video/soc_camera.c              |    8 ++-
 drivers/media/video/videobuf2-dma-contig.c    |    3 +-
 drivers/media/video/videobuf2-memops.c        |    1 +
 include/media/soc_camera.h                    |    3 +-
 16 files changed, 147 insertions(+), 118 deletions(-)

