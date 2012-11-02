Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881Ab2KBRGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:06:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:33059 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762332Ab2KBRGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:06:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/11] 3.4.18-stable review
Date: Fri,  2 Nov 2012 10:06:35 -0700
Message-Id: <20121102170314.204845540@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.18 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Nov  4 17:03:08 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.18-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.18-rc1

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: headless mode by default if pci class != vga display

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: fix suspend/resume when in headless mode

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: silence modesetting spam on pre-gf8 chipsets

Jiri Slaby <jslaby@suse.cz>
    HID: microsoft: fix invalid rdesc for 3k kbd

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix double-free of se_cmd in target_complete_tmr_failure

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix oops on unload when firmware not found

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    floppy: do put_disk on current dr if blk_init_queue fails

NeilBrown <neilb@suse.de>
    md/raid1: Fix assembling of arrays containing Replacements.

Mathias Nyman <mathias.nyman@linux.intel.com>
    gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

Dan Carpenter <dan.carpenter@oracle.com>
    gpio-timberdale: fix a potential wrapping issue

Eric Sandeen <sandeen@redhat.com>
    ext4: fix unjournaled inode bitmap modification


-------------

Diffstat:

 Makefile                                |  4 ++--
 drivers/block/floppy.c                  |  1 +
 drivers/gpio/gpio-timberdale.c          |  4 ++--
 drivers/gpio/gpiolib.c                  | 10 +++++++---
 drivers/gpu/drm/nouveau/nouveau_drv.c   | 20 +++++++++++---------
 drivers/gpu/drm/nouveau/nouveau_state.c |  4 +++-
 drivers/gpu/drm/nouveau/nv04_dac.c      |  8 ++++----
 drivers/gpu/drm/nouveau/nv04_dfp.c      |  6 +++---
 drivers/gpu/drm/nouveau/nv04_tv.c       |  4 ++--
 drivers/hid/hid-microsoft.c             | 18 +++++++++++++-----
 drivers/md/raid1.c                      |  2 +-
 drivers/net/wireless/b43/main.c         |  2 ++
 drivers/target/target_core_transport.c  |  1 -
 fs/ext4/ialloc.c                        | 19 +++++++++----------
 14 files changed, 60 insertions(+), 43 deletions(-)


