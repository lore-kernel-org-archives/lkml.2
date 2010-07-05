Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0GESoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:44:15 -0400
Received: from kroah.org ([198.145.64.141]:35197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0GESoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:12 -0400
Date: Mon, 5 Jul 2010 11:35:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.48
Message-ID: <20100705183537.GA31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.48 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/parisc/math-emu/decode_exc.c               |    1 
 arch/powerpc/lib/string.S                       |    4 
 arch/powerpc/oprofile/op_model_cell.c           |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   30 ---
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    8 
 arch/powerpc/platforms/pseries/smp.c            |   28 ++
 drivers/ata/libata-core.c                       |    7 
 drivers/char/ipmi/ipmi_si_intf.c                |   11 -
 drivers/md/md.c                                 |   29 ++
 drivers/md/raid1.c                              |    9 
 drivers/md/raid10.c                             |    2 
 drivers/net/arcnet/com20020-pci.c               |    4 
 fs/ext4/inode.c                                 |  240 +++++++++++++++++++-----
 fs/ext4/resize.c                                |    3 
 fs/namespace.c                                  |    9 
 fs/nfsd/nfssvc.c                                |    2 
 include/linux/fs.h                              |    2 
 include/net/sctp/structs.h                      |    1 
 mm/filemap.c                                    |    6 
 net/sctp/sm_make_chunk.c                        |   62 +++++-
 net/tipc/bearer.c                               |   37 ---
 net/tipc/bearer.h                               |    2 
 net/tipc/net.c                                  |   25 --
 scripts/kconfig/Makefile                        |    2 
 security/keys/keyring.c                         |   18 -
 security/keys/process_keys.c                    |    6 
 27 files changed, 393 insertions(+), 159 deletions(-)


Andreas Bombe (1):
      ARCNET: Limit com20020 PCI ID matches for SOHARD cards

Aneesh Kumar K.V (2):
      ext4: Fix file fragmentation during large file write.
      ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

Dan Carpenter (1):
      KEYS: Return more accurate error codes

Dan Williams (1):
      md: set mddev readonly flag on blkdev BLKROSET ioctl

Denis Kirjanov (1):
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

Eric Sandeen (1):
      ext4: check s_log_groups_per_flex in online resize code

Greg Kroah-Hartman (1):
      Linux 2.6.27.48

Helge Deller (1):
      parisc: clear floating point exception flag on SIGFPE signal

Jeff Mahoney (1):
      powerpc: Fix handling of strncmp with zero len

Jeff Moyer (1):
      do_generic_file_read: clear page errors when issuing a fresh read of the page

Jiri Kosina (1):
      ipmi: handle run_to_completion properly in deliver_recv_msg()

Michael Neuling (2):
      powerpc/pseries: Only call start-cpu when a CPU is stopped
      powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu

Miklos Szeredi (1):
      vfs: add NOFOLLOW flag to umount(2)

Neil Horman (2):
      sctp: Fix skb_over_panic resulting from multiple invalid parameter errors (CVE-2010-1173) (v4)
      tipc: Fix oops on send prior to entering networked mode (v3)

NeilBrown (2):
      md/raid1: fix counting of write targets.
      md: Fix read balancing in RAID1 and RAID10 on drives > 2TB

Pavel Emelyanov (1):
      NFSD: don't report compiled-out versions as present

Richard Kennedy (1):
      gconfig: fix build failure on fedora 13

Tejun Heo (1):
      libata: disable ATAPI AN by default

Theodore Ts'o (1):
      ext4: Use our own write_cache_pages()

Toshiyuki Okajima (1):
      KEYS: find_keyring_by_name() can gain access to a freed keyring

Wei Yongjun (1):
      sctp: fix append error cause to ERROR chunk correctly

