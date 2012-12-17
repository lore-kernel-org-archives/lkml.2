Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2LQW0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:26:36 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:29904 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2LQW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:26:35 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1355783193!6893949!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] HID: introduce, and use, module_hid_driver
Date: Mon, 17 Dec 2012 15:26:20 -0700
User-Agent: KMail/1.9.9
CC: <jkosina@suse.cz>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201212171526.21320.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce, and use, the helper macro module_hid_driver to allow removing
the init/exit boilerplate code from the HID drivers.

H Hartley Sweeten (3):
  HID: introduce helper for hid_driver boilerplate
  HID: hid.h: remove unused hid_generic_{init,exit} prototypes
  HID: Use module_hid_driver macro

 drivers/hid/hid-a4tech.c       | 13 +------------
 drivers/hid/hid-apple.c        | 19 +------------------
 drivers/hid/hid-aureal.c       | 13 +------------
 drivers/hid/hid-axff.c         | 14 +-------------
 drivers/hid/hid-belkin.c       | 13 +------------
 drivers/hid/hid-cherry.c       | 13 +------------
 drivers/hid/hid-chicony.c      | 13 +------------
 drivers/hid/hid-cypress.c      | 13 +------------
 drivers/hid/hid-dr.c           | 13 +------------
 drivers/hid/hid-elecom.c       | 13 +------------
 drivers/hid/hid-emsff.c        | 13 +------------
 drivers/hid/hid-ezkey.c        | 13 +------------
 drivers/hid/hid-gaff.c         | 13 +------------
 drivers/hid/hid-generic.c      | 14 +-------------
 drivers/hid/hid-gyration.c     | 13 +------------
 drivers/hid/hid-holtek-kbd.c   | 13 +------------
 drivers/hid/hid-holtekff.c     | 15 +--------------
 drivers/hid/hid-icade.c        | 19 +------------------
 drivers/hid/hid-kensington.c   | 13 +------------
 drivers/hid/hid-keytouch.c     | 13 +------------
 drivers/hid/hid-kye.c          | 13 +------------
 drivers/hid/hid-lcpower.c      | 13 +------------
 drivers/hid/hid-lenovo-tpkbd.c | 14 +-------------
 drivers/hid/hid-lg.c           | 13 +------------
 drivers/hid/hid-magicmouse.c   | 19 +------------------
 drivers/hid/hid-microsoft.c    | 13 +------------
 drivers/hid/hid-monterey.c     | 13 +------------
 drivers/hid/hid-multitouch.c   | 14 +-------------
 drivers/hid/hid-ntrig.c        | 13 +------------
 drivers/hid/hid-ortek.c        | 13 +------------
 drivers/hid/hid-petalynx.c     | 13 +------------
 drivers/hid/hid-picolcd_core.c | 13 +------------
 drivers/hid/hid-pl.c           | 13 +------------
 drivers/hid/hid-primax.c       | 13 +------------
 drivers/hid/hid-prodikeys.c    | 19 +------------------
 drivers/hid/hid-ps3remote.c    | 13 +------------
 drivers/hid/hid-roccat-lua.c   | 14 +-------------
 drivers/hid/hid-saitek.c       | 13 +------------
 drivers/hid/hid-samsung.c      | 13 +------------
 drivers/hid/hid-sensor-hub.c   | 14 +-------------
 drivers/hid/hid-sjoy.c         | 13 +------------
 drivers/hid/hid-sony.c         | 13 +------------
 drivers/hid/hid-speedlink.c    | 13 +------------
 drivers/hid/hid-sunplus.c      | 13 +------------
 drivers/hid/hid-tivo.c         | 13 +------------
 drivers/hid/hid-tmff.c         | 13 +------------
 drivers/hid/hid-topseed.c      | 13 +------------
 drivers/hid/hid-twinhan.c      | 13 +------------
 drivers/hid/hid-uclogic.c      | 13 +------------
 drivers/hid/hid-wacom.c        | 18 +-----------------
 drivers/hid/hid-waltop.c       | 13 +------------
 drivers/hid/hid-wiimote-core.c | 19 +------------------
 drivers/hid/hid-zpff.c         | 13 +------------
 drivers/hid/hid-zydacron.c     | 13 +------------
 include/linux/hid.h            | 15 ++++++++++++---
 55 files changed, 66 insertions(+), 694 deletions(-)

-- 
1.8.0.2

