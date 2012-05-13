Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2EMQHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:07:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47592 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2EMQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:43 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 0/7] Remove side-effects of CONFIG_EXPERT
Date: Sun, 13 May 2012 18:07:03 +0200
Message-Id: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EXPERT was designed to toggle visibility of config options.
However, we used it in several different places to change default values
or default selections. This may produce unwanted side-effects for users
who enable EXPERT mode to toggle a single config option.

Regards
David

David Herrmann (7):
  HID: Do not switch default values in EXPERT mode
  Media: Do not change default values in EXPERT mode
  rfkill: Do not change default values in EXPERT mode
  Kconfig: Do not switch default values in EXPERT mode
  usb: remove unneeded default value
  pcmcia: Do not change selected options in EXPERT mode
  drm: do not change selected options based on EXPERT mode

 drivers/gpu/drm/Kconfig             |    1 -
 drivers/gpu/drm/nouveau/Kconfig     |    1 -
 drivers/hid/Kconfig                 |   30 +++++++++++++++---------------
 drivers/media/common/tuners/Kconfig |    1 -
 drivers/media/dvb/frontends/Kconfig |    1 -
 drivers/media/video/Kconfig         |    2 +-
 drivers/pcmcia/Kconfig              |    1 -
 drivers/usb/core/Kconfig            |    1 -
 init/Kconfig                        |    2 +-
 net/rfkill/Kconfig                  |    2 +-
 usr/Kconfig                         |    8 ++++----
 11 files changed, 22 insertions(+), 28 deletions(-)

-- 
1.7.10.2

