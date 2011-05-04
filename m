Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1EDTTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab1EDTTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:19:53 -0400
Message-ID: <4DC1A6D2.6010603@redhat.com>
Date: Wed, 04 May 2011 16:19:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.39-rc7] V4L/DVB updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For one regression at v4l2 sub-devices, a few remote controler driver fixes, one Kconfig
missing dependency and one regression at ngene driver.

Thanks!
Mauro.

-


The following changes since commit 0ee5623f9a6e52df90a78bd21179f8ab370e102e:

  Linux 2.6.39-rc6 (2011-05-03 19:59:13 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Herton Ronaldo Krzesinski (1):
      [media] v4l: make sure drivers supply a zeroed struct v4l2_subdev

Hussam Al-Tayeb (1):
      [media] rc_core: avoid kernel oops when rmmod saa7134

Jarod Wilson (4):
      [media] mceusb: add Dell transceiver ID
      [media] ite-cir: modular build on ppc requires delay.h include
      [media] rc: show RC_TYPE_OTHER in sysfs
      [media] imon: add conditional locking in change_protocol

Malcolm Priestley (1):
      [media] Missing frontend config for LME DM04/QQBOX

Oliver Endriss (1):
      [media] ngene: Fix CI data transfer regression     Fix CI data transfer regression introduced by previous cleanup.

 drivers/media/dvb/dvb-usb/Kconfig    |    2 ++
 drivers/media/dvb/ngene/ngene-core.c |    1 +
 drivers/media/radio/saa7706h.c       |    2 +-
 drivers/media/radio/tef6862.c        |    2 +-
 drivers/media/rc/imon.c              |   31 +++++++++++++++++++++++++++----
 drivers/media/rc/ite-cir.c           |    1 +
 drivers/media/rc/mceusb.c            |    2 ++
 drivers/media/rc/rc-main.c           |    4 +++-
 drivers/media/video/m52790.c         |    2 +-
 drivers/media/video/tda9840.c        |    2 +-
 drivers/media/video/tea6415c.c       |    2 +-
 drivers/media/video/tea6420.c        |    2 +-
 drivers/media/video/upd64031a.c      |    2 +-
 drivers/media/video/upd64083.c       |    2 +-
 14 files changed, 44 insertions(+), 13 deletions(-)

