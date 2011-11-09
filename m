Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1KIMKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:10:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1KIMKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:10:30 -0500
Message-ID: <4EBA6DB2.6040106@redhat.com>
Date: Wed, 09 Nov 2011 10:10:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.2-rc2] media fixes
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a few V4L2 core and driver fixes, and one MAINTAINERS update for the s5p driver.

Thanks!
Mauro

-

Latest commit at the branch:
  1249a3a82d08d73ece65ae79e0553cd0f3407a15 [media] v4l2-ctrl: Send change events to all fh for auto cluster slave controls

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Hans de Goede (5):
      [media] uvcvideo: GET_RES should only be checked for BITMAP type menu controls
      [media] v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
      [media] v4l2-event: Remove pending events from fh event queue when unsubscribing
      [media] v4l2-event: Don't set sev->fh to NULL on unsubscribe
      [media] v4l2-ctrl: Send change events to all fh for auto cluster slave controls

Jeongtae Park (1):
      [media] MAINTAINERS: add a maintainer for s5p-mfc driver

Kamil Debski (1):
      [media] v4l: s5p-mfc: fix reported capabilities

Marek Szyprowski (3):
      [media] media: vb2: add a check for uninitialized buffer
      [media] media: vb2: set buffer length correctly for all buffer types
      [media] media: vb2: reset queued list on REQBUFS(0) call

Michael Krufky (4):
      [media] mxl111sf: fix return value of mxl111sf_idac_config
      [media] mxl111sf: check for errors after mxl111sf_write_reg in mxl111sf_idac_config
      [media] mxl111sf: remove pointless if condition in mxl111sf_config_spi
      [media] mxl111sf: fix build warning

 MAINTAINERS                               |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf-i2c.c  |    3 +--
 drivers/media/dvb/dvb-usb/mxl111sf-phy.c  |    7 ++++---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    4 ++--
 drivers/media/video/uvc/uvc_ctrl.c        |    6 ++++--
 drivers/media/video/v4l2-ctrls.c          |    5 +++--
 drivers/media/video/v4l2-event.c          |   10 +++++++++-
 drivers/media/video/videobuf2-core.c      |    6 ++++--
 9 files changed, 30 insertions(+), 16 deletions(-)

