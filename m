Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab0EZW1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:27:13 -0400
Received: from kroah.org ([198.145.64.141]:58604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421Ab0EZW1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:27:10 -0400
Date: Wed, 26 May 2010 15:23:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.47
Message-ID: <20100526222323.GA29493@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.47 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 
 arch/x86/kernel/process.c            |    6 
 drivers/acpi/processor_idle.c        |   13 +
 drivers/ata/libata-eh.c              |    6 
 drivers/char/tty_io.c                |    2 
 drivers/hwmon/w83781d.c              |   26 +--
 drivers/i2c/busses/i2c-i801.c        |    6 
 drivers/i2c/busses/i2c-tiny-usb.c    |   12 -
 drivers/i2c/i2c-core.c               |   24 ++-
 drivers/scsi/megaraid/megaraid_sas.c |   18 ++
 drivers/usb/core/inode.c             |    4 
 fs/ext4/balloc.c                     |   88 ++++++++++---
 fs/ext4/ext4.h                       |   13 +
 fs/ext4/ext4_sb.h                    |    1 
 fs/ext4/inode.c                      |  229 ++++++++++++++++++++++++-----------
 fs/ext4/mballoc.c                    |   39 +++--
 fs/ext4/super.c                      |    8 +
 fs/nfs/client.c                      |    2 
 fs/nfs/dir.c                         |    2 
 fs/nfsd/nfs4xdr.c                    |    8 -
 include/linux/percpu_counter.h       |   12 -
 include/linux/security.h             |   10 +
 include/linux/writeback.h            |    1 
 kernel/time/clockevents.c            |   16 +-
 kernel/time/tick-broadcast.c         |    7 -
 kernel/trace/trace.c                 |    2 
 lib/percpu_counter.c                 |    8 -
 mm/mmap.c                            |    3 
 mm/nommu.c                           |    3 
 mm/page-writeback.c                  |    2 
 mm/shmem.c                           |    8 -
 net/sunrpc/svc_xprt.c                |   25 ++-
 security/security.c                  |    9 +
 sound/pci/mixart/mixart.c            |   24 ++-
 34 files changed, 437 insertions(+), 202 deletions(-)

Al Viro (1):
      nfs d_revalidate() is too trigger-happy with d_drop()

Alan Cox (1):
      nfsd: fix vm overcommit crash

Aneesh Kumar K.V (7):
      ext4: invalidate pages if delalloc block allocation fails.
      ext4: Make sure all the block allocation paths reserve blocks
      ext4: Add percpu dirty block accounting.
      ext4: Retry block reservation
      ext4: Retry block allocation if we have free blocks left
      ext4: Use tag dirty lookup during mpage_da_submit_io
      vfs: Remove the range_cont writeback mode.

Chuck Lever (1):
      NFS: rsize and wsize settings ignored on v4 mounts

Dan Carpenter (2):
      ALSA: mixart: range checking proc file
      USB: fix testing the wrong variable in fs_create_by_name()

Greg Kroah-Hartman (1):
      Linux 2.6.27.47

Jean Delvare (4):
      i2c: Fix probing of FSC hardware monitoring chips
      hwmon: (w83781d) Request I/O ports individually for probing
      i2c-i801: Don't use the block buffer for I2C block writes
      i2c-tiny-usb: Fix on big-endian systems

Jeff Garzik (1):
      libata: ensure NCQ error result taskfile is fully initialized before returning it via qc->result_tf.

Junjiro R. Okajima (1):
      nfsd: fix vm overcommit crash fix #2

Mingming Cao (1):
      percpu counter: clean up percpu_counter_sum_and_set()

Neil Brown (1):
      nfsd4: bug in read_buf

Oleg Nesterov (1):
      tty: release_one_tty() forgets to put pids

Suresh Siddha (1):
      clockevent: Prevent dead lock on clockevents_lock

Tejun Heo (1):
      libata: retry FS IOs even if it has failed with AC_ERR_INVALID

Tom Tucker (1):
      svc: Clean up deferred requests on transport destruction

Tomas Henzl (1):
      megaraid_sas: fix for 32bit apps

Wang Sheng-Hui (1):
      trace: Fix inappropriate substraction on tracing_pages_allocated in trace_free_page()

