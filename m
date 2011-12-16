Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab1LPUvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:51:49 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38665 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932746Ab1LPUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:51:42 -0500
X-Sasl-enc: vZYw7WVaNJdZ5/sM2DmD8TdvufW9i6nyY1qQFPVYDzZn 1324068700
Date: Fri, 16 Dec 2011 12:50:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/16] 2.6.32.51-longterm review
Message-ID: <20111216205049.GA28030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.51 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by December 19, 2011, 18:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.51-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                 |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c |    6 +-
 arch/x86/oprofile/backtrace.c            |   46 +++++++++++++++++++--
 arch/x86/oprofile/nmi_int.c              |    8 ++--
 drivers/oprofile/buffer_sync.c           |   21 +++++-----
 drivers/usb/class/cdc-acm.c              |   10 +++++
 fs/ext4/inode.c                          |    2 +-
 fs/hfs/btree.c                           |   20 +++++++--
 fs/jbd/journal.c                         |    8 ++++
 fs/jbd2/journal.c                        |    8 ++++
 include/linux/log2.h                     |    1 -
 kernel/taskstats.c                       |    1 +
 mm/percpu.c                              |   32 +++++++++------
 mm/util.c                                |   13 ++++++
 net/xfrm/xfrm_algo.c                     |    4 +-
 sound/pci/hda/patch_realtek.c            |    2 +
 sound/pci/sis7019.c                      |   64 ++++++++++++++++++++++++-----
 17 files changed, 193 insertions(+), 55 deletions(-)
