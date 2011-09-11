Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab1IKO6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:58:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1IKO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:58:29 -0400
Message-ID: <4E6CCC90.2040701@redhat.com>
Date: Sun, 11 Sep 2011 11:58:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.1-rc5] media fixes
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	git://linuxtv.org/mchehab/for_linus.git v4l_for_linus

For a few driver fixes at pwc, vp7045, nuvotun-cir, viacam and gspca,
plus a fix at the V4L2 docbook.

Last commit at the branch: fc61ccd35fd59d5362d37c8bf9c0526c85086c84 [media] vp7045: fix buffer setup

Thanks,
Mauro

-

The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
  git://linuxtv.org/mchehab/for_linus.git v4l_for_linus

Dan Carpenter (1):
      [media] pwc: precedence bug in pwc_init_controls()

Florian Mickler (1):
      [media] vp7045: fix buffer setup

Jarod Wilson (1):
      [media] nuvoton-cir: simplify raw IR sample handling

Jean-François Moine (2):
      [media] gspca - ov519: Fix LED inversion of some ov519 webcams
      [media] gspca - sonixj: Fix the darkness of sensor om6802 in 320x240

Jesper Juhl (1):
      [media] [Resend] viacam: Don't explode if pci_find_bus() returns NULL

Kamil Debski (1):
      [media] v4l2: Fix documentation of the codec device controls

Luiz Carlos Ramos (1):
      [media] gspca - sonixj: Fix wrong register mask for sensor om6802

 Documentation/DocBook/media/v4l/controls.xml |   38 +++++++++++-----------
 drivers/media/dvb/dvb-usb/vp7045.c           |   26 ++------------
 drivers/media/rc/nuvoton-cir.c               |   45 ++++---------------------
 drivers/media/rc/nuvoton-cir.h               |    1 -
 drivers/media/video/gspca/ov519.c            |   22 ++++++-------
 drivers/media/video/gspca/sonixj.c           |    6 +++-
 drivers/media/video/pwc/pwc-v4l.c            |    2 +-
 drivers/media/video/via-camera.c             |    2 +
 8 files changed, 49 insertions(+), 93 deletions(-)

