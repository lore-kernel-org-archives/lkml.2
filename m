Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2AZSrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:47:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2AZSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:47:13 -0500
Message-ID: <4F219DD7.7050903@redhat.com>
Date: Thu, 26 Jan 2012 16:39:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.3-rc2] media fixes
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

>From a couple DVB driver fixes at anysee driver and cynergyT2, and a V4L
driver fix at atmel-isi.

Thanks!
Mauro

-

Latest commit at the branch: 
c79eba92406acc4898adcd1689fc21a6aa91ed0b [media] cinergyT2-fe: Fix bandwdith settings
The following changes since commit 36be126cb0ebe3000a65c1049f339a3e882a9a47:

  [media] as3645a: Fix compilation by including slab.h (2012-01-17 23:07:13 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Antti Palosaari (4):
      [media] cxd2820r: fix dvb_frontend_ops
      [media] cxd2820r: remove unused parameter from cxd2820r_attach
      [media] anysee: fix CI init
      [media] cxd2820r: sleep on DVB-T/T2 delivery system switch

Josh Wu (1):
      [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions

Mauro Carvalho Chehab (1):
      [media] cinergyT2-fe: Fix bandwdith settings

 drivers/media/dvb/dvb-usb/anysee.c          |   11 +++++++++--
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c    |    7 ++++---
 drivers/media/dvb/frontends/cxd2820r.h      |    6 ++----
 drivers/media/dvb/frontends/cxd2820r_core.c |   20 +++++++++++++++-----
 drivers/media/video/atmel-isi.c             |   14 ++++++++++++++
 drivers/media/video/em28xx/em28xx-dvb.c     |    3 +--
 6 files changed, 45 insertions(+), 16 deletions(-)

