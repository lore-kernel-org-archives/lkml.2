Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979Ab2KBRGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:06:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:32942 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761058Ab2KBRGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:06:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 0/4] 3.0.51-stable review
Date: Fri,  2 Nov 2012 10:06:04 -0700
Message-Id: <20121102170333.581931288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.51 release.
There are 4 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Nov  4 17:03:28 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.51-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.51-rc1

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: silence modesetting spam on pre-gf8 chipsets

Jan Kara <jack@suse.cz>
    mm: fix XFS oops due to dirty pages without buffers on s390

Len Brown <len.brown@intel.com>
    x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    floppy: do put_disk on current dr if blk_init_queue fails


-------------

Diffstat:

 Documentation/feature-removal-schedule.txt |  8 -------
 Makefile                                   |  4 ++--
 arch/x86/include/asm/system.h              |  7 ------
 arch/x86/kernel/process.c                  | 24 -------------------
 drivers/block/floppy.c                     | 37 +-----------------------------
 drivers/gpu/drm/nouveau/nv04_dac.c         |  8 +++----
 drivers/gpu/drm/nouveau/nv04_dfp.c         |  6 ++---
 drivers/gpu/drm/nouveau/nv04_tv.c          |  4 ++--
 mm/rmap.c                                  | 21 +++++++++++++----
 9 files changed, 28 insertions(+), 91 deletions(-)


