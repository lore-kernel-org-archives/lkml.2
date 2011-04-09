Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1DIDhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 23:37:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39335 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1DIDhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 23:37:39 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=3rvgeqzMqd0A:10 a=B2sCdJAaY-oA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=xUGo1ZbFs9YocPazvnAA:9 a=KpB-InZ9c2q-FuK0nqgA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 08 Apr 2011 22:37:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: rt2860sta and rt2870sta: Remove drivers replaced in net/wireless
Message-ID: <4d9fd480.hAgzst+KKyLoglqZ%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32759907431a113b5f4e4de7b34efdb485b474d3 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 7 Apr 2011 17:01:19 -0500
Subject: [PATCH] staging: rt2860sta and rt2870sta: Remove drivers replaced in net/wireless

The staging driver rt2860sta is replaced by mainline driver rt2800pci, and
rt2870sta is replaced by rt2800usb. As a result, the staging drivers are
deleted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Greg,

This patch can be pulled from

git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/linux-staging.git

Larry

---
 drivers/staging/Kconfig                      |    4 -
 drivers/staging/Makefile                     |    2 -
 drivers/staging/rt2860/Kconfig               |   10 -
 drivers/staging/rt2860/Makefile              |   52 -
 drivers/staging/rt2860/TODO                  |   16 -
 drivers/staging/rt2860/ap.h                  |   68 -
 drivers/staging/rt2860/chip/mac_pci.h        |  355 --
 drivers/staging/rt2860/chip/mac_usb.h        |  345 --
 drivers/staging/rt2860/chip/rt2860.h         |   54 -
 drivers/staging/rt2860/chip/rt2870.h         |   46 -
 drivers/staging/rt2860/chip/rt3070.h         |   67 -
 drivers/staging/rt2860/chip/rt3090.h         |   72 -
 drivers/staging/rt2860/chip/rt30xx.h         |   47 -
 drivers/staging/rt2860/chip/rtmp_mac.h       | 1308 ------
 drivers/staging/rt2860/chip/rtmp_phy.h       |  516 ---
 drivers/staging/rt2860/chips/rt3070.c        |  169 -
 drivers/staging/rt2860/chips/rt3090.c        |  121 -
 drivers/staging/rt2860/chips/rt30xx.c        |  516 ---
 drivers/staging/rt2860/chlist.h              |  113 -
 drivers/staging/rt2860/common/action.c       |  606 ---
 drivers/staging/rt2860/common/action.h       |   56 -
 drivers/staging/rt2860/common/ba_action.c    | 1650 -------
 drivers/staging/rt2860/common/cmm_aes.c      | 1311 ------
 drivers/staging/rt2860/common/cmm_asic.c     | 2565 -----------
 drivers/staging/rt2860/common/cmm_cfg.c      |  258 --
 drivers/staging/rt2860/common/cmm_data.c     | 2361 ----------
 drivers/staging/rt2860/common/cmm_data_pci.c | 1096 -----
 drivers/staging/rt2860/common/cmm_data_usb.c |  951 ----
 drivers/staging/rt2860/common/cmm_info.c     |  955 ----
 drivers/staging/rt2860/common/cmm_mac_pci.c  | 1661 -------
 drivers/staging/rt2860/common/cmm_mac_usb.c  | 1162 -----
 drivers/staging/rt2860/common/cmm_sanity.c   | 1205 -----
 drivers/staging/rt2860/common/cmm_sync.c     |  718 ---
 drivers/staging/rt2860/common/cmm_tkip.c     |  833 ----
 drivers/staging/rt2860/common/cmm_wep.c      |  473 --
 drivers/staging/rt2860/common/cmm_wpa.c      | 3010 -------------
 drivers/staging/rt2860/common/crypt_hmac.c   |  187 -
 drivers/staging/rt2860/common/crypt_md5.c    |  339 --
 drivers/staging/rt2860/common/crypt_sha2.c   |  269 --
 drivers/staging/rt2860/common/dfs.c          |   68 -
 drivers/staging/rt2860/common/ee_efuse.c     |  351 --
 drivers/staging/rt2860/common/ee_prom.c      |  197 -
 drivers/staging/rt2860/common/eeprom.c       |   91 -
 drivers/staging/rt2860/common/mlme.c         | 6068 --------------------------
 drivers/staging/rt2860/common/rt_channel.c   | 1705 --------
 drivers/staging/rt2860/common/rt_rf.c        |  187 -
 drivers/staging/rt2860/common/rtmp_init.c    | 3536 ---------------
 drivers/staging/rt2860/common/rtmp_mcu.c     |  336 --
 drivers/staging/rt2860/common/rtmp_timer.c   |  302 --
 drivers/staging/rt2860/common/spectrum.c     | 2205 ----------
 drivers/staging/rt2860/crypt_hmac.h          |   65 -
 drivers/staging/rt2860/crypt_md5.h           |   73 -
 drivers/staging/rt2860/crypt_sha2.h          |   73 -
 drivers/staging/rt2860/dfs.h                 |   39 -
 drivers/staging/rt2860/eeprom.h              |   67 -
 drivers/staging/rt2860/iface/rtmp_pci.h      |   80 -
 drivers/staging/rt2860/iface/rtmp_usb.h      |  196 -
 drivers/staging/rt2860/mlme.h                | 1050 -----
 drivers/staging/rt2860/oid.h                 |  779 ----
 drivers/staging/rt2860/pci_main_dev.c        | 1192 -----
 drivers/staging/rt2860/rt_config.h           |   71 -
 drivers/staging/rt2860/rt_linux.c            | 1367 ------
 drivers/staging/rt2860/rt_linux.h            |  835 ----
 drivers/staging/rt2860/rt_main_dev.c         |  736 ----
 drivers/staging/rt2860/rt_pci_rbus.c         |  837 ----
 drivers/staging/rt2860/rt_usb.c              |  794 ----
 drivers/staging/rt2860/rtmp.h                | 4332 ------------------
 drivers/staging/rt2860/rtmp_chip.h           |  258 --
 drivers/staging/rt2860/rtmp_ckipmic.h        |   63 -
 drivers/staging/rt2860/rtmp_def.h            | 1427 ------
 drivers/staging/rt2860/rtmp_dot11.h          |  100 -
 drivers/staging/rt2860/rtmp_iface.h          |   75 -
 drivers/staging/rt2860/rtmp_mcu.h            |   49 -
 drivers/staging/rt2860/rtmp_os.h             |   90 -
 drivers/staging/rt2860/rtmp_timer.h          |  148 -
 drivers/staging/rt2860/rtmp_type.h           |   89 -
 drivers/staging/rt2860/rtusb_io.h            |  185 -
 drivers/staging/rt2860/spectrum.h            |  189 -
 drivers/staging/rt2860/spectrum_def.h        |  202 -
 drivers/staging/rt2860/sta/assoc.c           | 1602 -------
 drivers/staging/rt2860/sta/auth.c            |  517 ---
 drivers/staging/rt2860/sta/auth_rsp.c        |  142 -
 drivers/staging/rt2860/sta/connect.c         | 2613 -----------
 drivers/staging/rt2860/sta/rtmp_data.c       | 2552 -----------
 drivers/staging/rt2860/sta/sanity.c          |  362 --
 drivers/staging/rt2860/sta/sync.c            | 1968 ---------
 drivers/staging/rt2860/sta/wpa.c             |  374 --
 drivers/staging/rt2860/sta_ioctl.c           | 2912 ------------
 drivers/staging/rt2860/usb_main_dev.c        |  927 ----
 drivers/staging/rt2860/wpa.h                 |  390 --
 drivers/staging/rt2870/Kconfig               |    9 -
 drivers/staging/rt2870/Makefile              |   55 -
 drivers/staging/rt2870/TODO                  |   17 -
 drivers/staging/rt2870/aironet.h             |    1 -
 drivers/staging/rt2870/ap.h                  |    1 -
 drivers/staging/rt2870/chips/rt3070.c        |    1 -
 drivers/staging/rt2870/chips/rt30xx.c        |    1 -
 drivers/staging/rt2870/chlist.h              |    1 -
 drivers/staging/rt2870/common/acction.c      |    1 -
 drivers/staging/rt2870/common/action.c       |    1 -
 drivers/staging/rt2870/common/action.h       |    1 -
 drivers/staging/rt2870/common/ba_action.c    |    1 -
 drivers/staging/rt2870/common/cmm_aes.c      |    1 -
 drivers/staging/rt2870/common/cmm_asic.c     |    1 -
 drivers/staging/rt2870/common/cmm_cfg.c      |    1 -
 drivers/staging/rt2870/common/cmm_data.c     |    1 -
 drivers/staging/rt2870/common/cmm_data_usb.c |    1 -
 drivers/staging/rt2870/common/cmm_info.c     |    1 -
 drivers/staging/rt2870/common/cmm_mac_usb.c  |    1 -
 drivers/staging/rt2870/common/cmm_profile.c  |    1 -
 drivers/staging/rt2870/common/cmm_sanity.c   |    1 -
 drivers/staging/rt2870/common/cmm_sync.c     |    1 -
 drivers/staging/rt2870/common/cmm_tkip.c     |    1 -
 drivers/staging/rt2870/common/cmm_wep.c      |    1 -
 drivers/staging/rt2870/common/cmm_wpa.c      |    1 -
 drivers/staging/rt2870/common/crypt_hmac.c   |    1 -
 drivers/staging/rt2870/common/crypt_md5.c    |    1 -
 drivers/staging/rt2870/common/crypt_sha2.c   |    1 -
 drivers/staging/rt2870/common/dfs.c          |    1 -
 drivers/staging/rt2870/common/ee_efuse.c     |    1 -
 drivers/staging/rt2870/common/eeprom.c       |    1 -
 drivers/staging/rt2870/common/md5.c          |    1 -
 drivers/staging/rt2870/common/mlme.c         |    1 -
 drivers/staging/rt2870/common/rt_channel.c   |    1 -
 drivers/staging/rt2870/common/rt_rf.c        |    1 -
 drivers/staging/rt2870/common/rtmp_init.c    |    1 -
 drivers/staging/rt2870/common/rtmp_mcu.c     |    1 -
 drivers/staging/rt2870/common/rtmp_timer.c   |    1 -
 drivers/staging/rt2870/common/rtmp_tkip.c    |    1 -
 drivers/staging/rt2870/common/rtmp_wep.c     |    1 -
 drivers/staging/rt2870/common/rtusb_bulk.c   | 1232 ------
 drivers/staging/rt2870/common/rtusb_data.c   |  262 --
 drivers/staging/rt2870/common/rtusb_io.c     | 2104 ---------
 drivers/staging/rt2870/common/spectrum.c     |    1 -
 drivers/staging/rt2870/dfs.h                 |    1 -
 drivers/staging/rt2870/md5.h                 |    1 -
 drivers/staging/rt2870/mlme.h                |    1 -
 drivers/staging/rt2870/oid.h                 |    1 -
 drivers/staging/rt2870/rt28xx.h              |    1 -
 drivers/staging/rt2870/rt_config.h           |    1 -
 drivers/staging/rt2870/rt_linux.c            |    1 -
 drivers/staging/rt2870/rt_linux.h            |    1 -
 drivers/staging/rt2870/rt_main_dev.c         |    1 -
 drivers/staging/rt2870/rt_profile.c          |    1 -
 drivers/staging/rt2870/rt_usb.c              |    1 -
 drivers/staging/rt2870/rtmp.h                |    1 -
 drivers/staging/rt2870/rtmp_ckipmic.h        |    1 -
 drivers/staging/rt2870/rtmp_def.h            |    1 -
 drivers/staging/rt2870/rtmp_type.h           |    1 -
 drivers/staging/rt2870/spectrum.h            |    1 -
 drivers/staging/rt2870/spectrum_def.h        |    1 -
 drivers/staging/rt2870/sta/aironet.c         |    1 -
 drivers/staging/rt2870/sta/assoc.c           |    1 -
 drivers/staging/rt2870/sta/auth.c            |    1 -
 drivers/staging/rt2870/sta/auth_rsp.c        |    1 -
 drivers/staging/rt2870/sta/connect.c         |    1 -
 drivers/staging/rt2870/sta/rtmp_data.c       |    1 -
 drivers/staging/rt2870/sta/sanity.c          |    1 -
 drivers/staging/rt2870/sta/sync.c            |    1 -
 drivers/staging/rt2870/sta/wpa.c             |    1 -
 drivers/staging/rt2870/sta_ioctl.c           |    1 -
 drivers/staging/rt2870/usb_main_dev.c        |    1 -
 drivers/staging/rt2870/wpa.h                 |    1 -
 163 files changed, 0 insertions(+), 74159 deletions(-)
 delete mode 100644 drivers/staging/rt2860/Kconfig
 delete mode 100644 drivers/staging/rt2860/Makefile
 delete mode 100644 drivers/staging/rt2860/TODO
 delete mode 100644 drivers/staging/rt2860/ap.h
 delete mode 100644 drivers/staging/rt2860/chip/mac_pci.h
 delete mode 100644 drivers/staging/rt2860/chip/mac_usb.h
 delete mode 100644 drivers/staging/rt2860/chip/rt2860.h
 delete mode 100644 drivers/staging/rt2860/chip/rt2870.h
 delete mode 100644 drivers/staging/rt2860/chip/rt3070.h
 delete mode 100644 drivers/staging/rt2860/chip/rt3090.h
 delete mode 100644 drivers/staging/rt2860/chip/rt30xx.h
 delete mode 100644 drivers/staging/rt2860/chip/rtmp_mac.h
 delete mode 100644 drivers/staging/rt2860/chip/rtmp_phy.h
 delete mode 100644 drivers/staging/rt2860/chips/rt3070.c
 delete mode 100644 drivers/staging/rt2860/chips/rt3090.c
 delete mode 100644 drivers/staging/rt2860/chips/rt30xx.c
 delete mode 100644 drivers/staging/rt2860/chlist.h
 delete mode 100644 drivers/staging/rt2860/common/action.c
 delete mode 100644 drivers/staging/rt2860/common/action.h
 delete mode 100644 drivers/staging/rt2860/common/ba_action.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_aes.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_asic.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_cfg.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_data.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_data_pci.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_data_usb.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_info.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_mac_pci.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_mac_usb.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_sanity.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_sync.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_tkip.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_wep.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_wpa.c
 delete mode 100644 drivers/staging/rt2860/common/crypt_hmac.c
 delete mode 100644 drivers/staging/rt2860/common/crypt_md5.c
 delete mode 100644 drivers/staging/rt2860/common/crypt_sha2.c
 delete mode 100644 drivers/staging/rt2860/common/dfs.c
 delete mode 100644 drivers/staging/rt2860/common/ee_efuse.c
 delete mode 100644 drivers/staging/rt2860/common/ee_prom.c
 delete mode 100644 drivers/staging/rt2860/common/eeprom.c
 delete mode 100644 drivers/staging/rt2860/common/mlme.c
 delete mode 100644 drivers/staging/rt2860/common/rt_channel.c
 delete mode 100644 drivers/staging/rt2860/common/rt_rf.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_init.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_mcu.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_timer.c
 delete mode 100644 drivers/staging/rt2860/common/spectrum.c
 delete mode 100644 drivers/staging/rt2860/crypt_hmac.h
 delete mode 100644 drivers/staging/rt2860/crypt_md5.h
 delete mode 100644 drivers/staging/rt2860/crypt_sha2.h
 delete mode 100644 drivers/staging/rt2860/dfs.h
 delete mode 100644 drivers/staging/rt2860/eeprom.h
 delete mode 100644 drivers/staging/rt2860/iface/rtmp_pci.h
 delete mode 100644 drivers/staging/rt2860/iface/rtmp_usb.h
 delete mode 100644 drivers/staging/rt2860/mlme.h
 delete mode 100644 drivers/staging/rt2860/oid.h
 delete mode 100644 drivers/staging/rt2860/pci_main_dev.c
 delete mode 100644 drivers/staging/rt2860/rt_config.h
 delete mode 100644 drivers/staging/rt2860/rt_linux.c
 delete mode 100644 drivers/staging/rt2860/rt_linux.h
 delete mode 100644 drivers/staging/rt2860/rt_main_dev.c
 delete mode 100644 drivers/staging/rt2860/rt_pci_rbus.c
 delete mode 100644 drivers/staging/rt2860/rt_usb.c
 delete mode 100644 drivers/staging/rt2860/rtmp.h
 delete mode 100644 drivers/staging/rt2860/rtmp_chip.h
 delete mode 100644 drivers/staging/rt2860/rtmp_ckipmic.h
 delete mode 100644 drivers/staging/rt2860/rtmp_def.h
 delete mode 100644 drivers/staging/rt2860/rtmp_dot11.h
 delete mode 100644 drivers/staging/rt2860/rtmp_iface.h
 delete mode 100644 drivers/staging/rt2860/rtmp_mcu.h
 delete mode 100644 drivers/staging/rt2860/rtmp_os.h
 delete mode 100644 drivers/staging/rt2860/rtmp_timer.h
 delete mode 100644 drivers/staging/rt2860/rtmp_type.h
 delete mode 100644 drivers/staging/rt2860/rtusb_io.h
 delete mode 100644 drivers/staging/rt2860/spectrum.h
 delete mode 100644 drivers/staging/rt2860/spectrum_def.h
 delete mode 100644 drivers/staging/rt2860/sta/assoc.c
 delete mode 100644 drivers/staging/rt2860/sta/auth.c
 delete mode 100644 drivers/staging/rt2860/sta/auth_rsp.c
 delete mode 100644 drivers/staging/rt2860/sta/connect.c
 delete mode 100644 drivers/staging/rt2860/sta/rtmp_data.c
 delete mode 100644 drivers/staging/rt2860/sta/sanity.c
 delete mode 100644 drivers/staging/rt2860/sta/sync.c
 delete mode 100644 drivers/staging/rt2860/sta/wpa.c
 delete mode 100644 drivers/staging/rt2860/sta_ioctl.c
 delete mode 100644 drivers/staging/rt2860/usb_main_dev.c
 delete mode 100644 drivers/staging/rt2860/wpa.h
 delete mode 100644 drivers/staging/rt2870/Kconfig
 delete mode 100644 drivers/staging/rt2870/Makefile
 delete mode 100644 drivers/staging/rt2870/TODO
 delete mode 100644 drivers/staging/rt2870/aironet.h
 delete mode 100644 drivers/staging/rt2870/ap.h
 delete mode 100644 drivers/staging/rt2870/chips/rt3070.c
 delete mode 100644 drivers/staging/rt2870/chips/rt30xx.c
 delete mode 100644 drivers/staging/rt2870/chlist.h
 delete mode 100644 drivers/staging/rt2870/common/acction.c
 delete mode 100644 drivers/staging/rt2870/common/action.c
 delete mode 100644 drivers/staging/rt2870/common/action.h
 delete mode 100644 drivers/staging/rt2870/common/ba_action.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_aes.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_asic.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_cfg.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_data.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_data_usb.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_info.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_mac_usb.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_profile.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_sanity.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_sync.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_tkip.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_wep.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_wpa.c
 delete mode 100644 drivers/staging/rt2870/common/crypt_hmac.c
 delete mode 100644 drivers/staging/rt2870/common/crypt_md5.c
 delete mode 100644 drivers/staging/rt2870/common/crypt_sha2.c
 delete mode 100644 drivers/staging/rt2870/common/dfs.c
 delete mode 100644 drivers/staging/rt2870/common/ee_efuse.c
 delete mode 100644 drivers/staging/rt2870/common/eeprom.c
 delete mode 100644 drivers/staging/rt2870/common/md5.c
 delete mode 100644 drivers/staging/rt2870/common/mlme.c
 delete mode 100644 drivers/staging/rt2870/common/rt_channel.c
 delete mode 100644 drivers/staging/rt2870/common/rt_rf.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_init.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_mcu.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_timer.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_tkip.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_wep.c
 delete mode 100644 drivers/staging/rt2870/common/rtusb_bulk.c
 delete mode 100644 drivers/staging/rt2870/common/rtusb_data.c
 delete mode 100644 drivers/staging/rt2870/common/rtusb_io.c
 delete mode 100644 drivers/staging/rt2870/common/spectrum.c
 delete mode 100644 drivers/staging/rt2870/dfs.h
 delete mode 100644 drivers/staging/rt2870/md5.h
 delete mode 100644 drivers/staging/rt2870/mlme.h
 delete mode 100644 drivers/staging/rt2870/oid.h
 delete mode 100644 drivers/staging/rt2870/rt28xx.h
 delete mode 100644 drivers/staging/rt2870/rt_config.h
 delete mode 100644 drivers/staging/rt2870/rt_linux.c
 delete mode 100644 drivers/staging/rt2870/rt_linux.h
 delete mode 100644 drivers/staging/rt2870/rt_main_dev.c
 delete mode 100644 drivers/staging/rt2870/rt_profile.c
 delete mode 100644 drivers/staging/rt2870/rt_usb.c
 delete mode 100644 drivers/staging/rt2870/rtmp.h
 delete mode 100644 drivers/staging/rt2870/rtmp_ckipmic.h
 delete mode 100644 drivers/staging/rt2870/rtmp_def.h
 delete mode 100644 drivers/staging/rt2870/rtmp_type.h
 delete mode 100644 drivers/staging/rt2870/spectrum.h
 delete mode 100644 drivers/staging/rt2870/spectrum_def.h
 delete mode 100644 drivers/staging/rt2870/sta/aironet.c
 delete mode 100644 drivers/staging/rt2870/sta/assoc.c
 delete mode 100644 drivers/staging/rt2870/sta/auth.c
 delete mode 100644 drivers/staging/rt2870/sta/auth_rsp.c
 delete mode 100644 drivers/staging/rt2870/sta/connect.c
 delete mode 100644 drivers/staging/rt2870/sta/rtmp_data.c
 delete mode 100644 drivers/staging/rt2870/sta/sanity.c
 delete mode 100644 drivers/staging/rt2870/sta/sync.c
 delete mode 100644 drivers/staging/rt2870/sta/wpa.c
 delete mode 100644 drivers/staging/rt2870/sta_ioctl.c
 delete mode 100644 drivers/staging/rt2870/usb_main_dev.c
 delete mode 100644 drivers/staging/rt2870/wpa.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 18b43fc..58a458e 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -67,10 +67,6 @@ source "drivers/staging/echo/Kconfig"
 
 source "drivers/staging/brcm80211/Kconfig"
 
-source "drivers/staging/rt2860/Kconfig"
-
-source "drivers/staging/rt2870/Kconfig"
-
 source "drivers/staging/comedi/Kconfig"
 
 source "drivers/staging/olpc_dcon/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index cfd13cd..d2a8f25 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -17,8 +17,6 @@ obj-$(CONFIG_W35UND)		+= winbond/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
 obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_BRCM80211)		+= brcm80211/
-obj-$(CONFIG_RT2860)		+= rt2860/
-obj-$(CONFIG_RT2870)		+= rt2870/
 obj-$(CONFIG_COMEDI)		+= comedi/
 obj-$(CONFIG_FB_OLPC_DCON)	+= olpc_dcon/
 obj-$(CONFIG_ASUS_OLED)		+= asus_oled/

diff data for file deletions removed.

