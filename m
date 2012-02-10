Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2BJFki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:40:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2BJFkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:40:36 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>
Subject: [Resend PATCH 00/60] highmem: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:21 +0800
Message-Id: <1328852421-19678-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

This is a resend of my patches in kmap_atomic tree, it stays in
linux-next for a long time.

Signed-off-by: Cong Wang <amwang@redhat.com>
-------------------

Cong Wang (60):
  highmem: mark k[un]map_atomic() with two arguments as deprecated
  include/linux/highmem.h: remove the second argument of
    k[un]map_atomic()
  arm: remove the second argument of k[un]map_atomic()
  mips: remove the second argument of k[un]map_atomic()
  powerpc: remove the second argument of k[un]map_atomic()
  sh: remove the second argument of k[un]map_atomic()
  um: remove the second argument of k[un]map_atomic()
  x86: remove the second argument of k[un]map_atomic()
  crypto: remove the second argument of k[un]map_atomic()
  ata: remove the second argument of k[un]map_atomic()
  block: remove the second argument of k[un]map_atomic()
  crypto: remove the second argument of k[un]map_atomic()
  edac: remove the second argument of k[un]map_atomic()
  drm: remove the second argument of k[un]map_atomic()
  ide: remove the second argument of k[un]map_atomic()
  infiniband: remove the second argument of k[un]map_atomic()
  md: remove the second argument of k[un]map_atomic()
  media: remove the second argument of k[un]map_atomic()
  memstick: remove the second argument of k[un]map_atomic()
  net: remove the second argument of k[un]map_atomic()
  scsi: remove the second argument of k[un]map_atomic()
  hv: remove the second argument of k[un]map_atomic()
  rtl8192u: remove the second argument of k[un]map_atomic()
  zram: remove the second argument of k[un]map_atomic()
  target: remove the second argument of k[un]map_atomic()
  vhost: remove the second argument of k[un]map_atomic()
  fs: remove the second argument of k[un]map_atomic()
  btrfs: remove the second argument of k[un]map_atomic()
  ecryptfs: remove the second argument of k[un]map_atomic()
  afs: remove the second argument of k[un]map_atomic()
  exofs: remove the second argument of k[un]map_atomic()
  ext2: remove the second argument of k[un]map_atomic()
  fuse: remove the second argument of k[un]map_atomic()
  gfs2: remove the second argument of k[un]map_atomic()
  jbd: remove the second argument of k[un]map_atomic()
  jbd2: remove the second argument of k[un]map_atomic()
  logfs: remove the second argument of k[un]map_atomic()
  minix: remove the second argument of k[un]map_atomic()
  nfs: remove the second argument of k[un]map_atomic()
  nilfs2: remove the second argument of k[un]map_atomic()
  ntfs: remove the second argument of k[un]map_atomic()
  ocfs2: remove the second argument of k[un]map_atomic()
  reiserfs: remove the second argument of k[un]map_atomic()
  squashfs: remove the second argument of k[un]map_atomic()
  ubifs: remove the second argument of k[un]map_atomic()
  udf: remove the second argument of k[un]map_atomic()
  kdb: remove the second argument of k[un]map_atomic()
  power: remove the second argument of k[un]map_atomic()
  lib: remove the second argument of k[un]map_atomic()
  mm: remove the second argument of k[un]map_atomic()
  net: remove the second argument of k[un]map_atomic()
  rds: remove the second argument of k[un]map_atomic()
  sunrpc: remove the second argument of k[un]map_atomic()
  tomoyo: remove the second argument of k[un]map_atomic()
  dm: remove the second argument of k[un]map_atomic()
  gma500: remove the second argument of k[un]map_atomic()
  zcache: remove the second argument of k[un]map_atomic()
  drbd: remove the second argument of k[un]map_atomic()
  highmem: kill all __kmap_atomic()     [swarren@nvidia.com: highmem:
    Fix ARM build break due to __kmap_atomic rename]
  feature-removal-schedule.txt: schedule the deprecated form of
    kmap_atomic() for removal

 Documentation/feature-removal-schedule.txt       |    8 ++
 arch/arm/include/asm/highmem.h                   |    2 +-
 arch/arm/mm/copypage-fa.c                        |   12 ++--
 arch/arm/mm/copypage-feroceon.c                  |   12 ++--
 arch/arm/mm/copypage-v3.c                        |   12 ++--
 arch/arm/mm/copypage-v4mc.c                      |    8 +-
 arch/arm/mm/copypage-v4wb.c                      |   12 ++--
 arch/arm/mm/copypage-v4wt.c                      |   12 ++--
 arch/arm/mm/copypage-v6.c                        |   12 ++--
 arch/arm/mm/copypage-xsc3.c                      |   12 ++--
 arch/arm/mm/copypage-xscale.c                    |    8 +-
 arch/arm/mm/highmem.c                            |    4 +-
 arch/frv/include/asm/highmem.h                   |    2 +-
 arch/frv/mm/highmem.c                            |    4 +-
 arch/mips/include/asm/highmem.h                  |    2 +-
 arch/mips/mm/c-r4k.c                             |    4 +-
 arch/mips/mm/highmem.c                           |    4 +-
 arch/mips/mm/init.c                              |    8 +-
 arch/mn10300/include/asm/highmem.h               |    2 +-
 arch/parisc/include/asm/cacheflush.h             |    2 +-
 arch/powerpc/include/asm/highmem.h               |    2 +-
 arch/powerpc/kvm/book3s_pr.c                     |    4 +-
 arch/powerpc/mm/dma-noncoherent.c                |    5 +-
 arch/powerpc/mm/hugetlbpage.c                    |    4 +-
 arch/powerpc/mm/mem.c                            |    4 +-
 arch/sh/mm/cache-sh4.c                           |    4 +-
 arch/sh/mm/cache.c                               |   12 ++--
 arch/sparc/include/asm/highmem.h                 |    2 +-
 arch/sparc/mm/highmem.c                          |    4 +-
 arch/tile/include/asm/highmem.h                  |    2 +-
 arch/tile/mm/highmem.c                           |    4 +-
 arch/um/kernel/skas/uaccess.c                    |    4 +-
 arch/x86/crypto/aesni-intel_glue.c               |   24 +++---
 arch/x86/include/asm/highmem.h                   |    2 +-
 arch/x86/kernel/crash_dump_32.c                  |    6 +-
 arch/x86/kvm/lapic.c                             |    8 +-
 arch/x86/kvm/paging_tmpl.h                       |    4 +-
 arch/x86/kvm/x86.c                               |    8 +-
 arch/x86/lib/usercopy_32.c                       |    4 +-
 arch/x86/mm/highmem_32.c                         |    4 +-
 crypto/ahash.c                                   |    4 +-
 crypto/async_tx/async_memcpy.c                   |    8 +-
 crypto/blkcipher.c                               |    8 +-
 crypto/ccm.c                                     |    4 +-
 crypto/scatterwalk.c                             |    8 +-
 crypto/shash.c                                   |    8 +-
 drivers/ata/libata-sff.c                         |    8 +-
 drivers/block/brd.c                              |   20 +++---
 drivers/block/drbd/drbd_bitmap.c                 |   50 ++++++------
 drivers/block/drbd/drbd_nl.c                     |    4 +-
 drivers/block/loop.c                             |   16 ++--
 drivers/block/pktcdvd.c                          |    8 +-
 drivers/crypto/hifn_795x.c                       |   10 +-
 drivers/edac/edac_mc.c                           |    4 +-
 drivers/gpu/drm/drm_cache.c                      |    8 +-
 drivers/gpu/drm/gma500/mmu.c                     |   30 ++++----
 drivers/gpu/drm/ttm/ttm_tt.c                     |   16 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c              |    6 +-
 drivers/ide/ide-taskfile.c                       |    4 +-
 drivers/infiniband/ulp/iser/iser_memory.c        |    8 +-
 drivers/md/bitmap.c                              |   42 +++++-----
 drivers/md/dm-crypt.c                            |    8 +-
 drivers/media/video/ivtv/ivtv-udma.c             |    4 +-
 drivers/memstick/host/jmb38x_ms.c                |    4 +-
 drivers/memstick/host/tifm_ms.c                  |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c    |    6 +-
 drivers/net/ethernet/intel/e1000e/netdev.c       |   10 +--
 drivers/net/ethernet/sun/cassini.c               |    4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                 |    8 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                |    5 +-
 drivers/scsi/cxgbi/libcxgbi.c                    |    5 +-
 drivers/scsi/fcoe/fcoe.c                         |    4 +-
 drivers/scsi/fcoe/fcoe_transport.c               |    5 +-
 drivers/scsi/gdth.c                              |    4 +-
 drivers/scsi/ips.c                               |    6 +-
 drivers/scsi/isci/request.c                      |   16 ++--
 drivers/scsi/libfc/fc_fcp.c                      |    8 +-
 drivers/scsi/libfc/fc_libfc.c                    |    8 +-
 drivers/scsi/libfc/fc_libfc.h                    |    2 +-
 drivers/scsi/libfc/fc_lport.c                    |    2 +-
 drivers/scsi/libiscsi_tcp.c                      |    4 +-
 drivers/scsi/libsas/sas_host_smp.c               |    8 +-
 drivers/scsi/megaraid.c                          |    4 +-
 drivers/scsi/mvsas/mv_sas.c                      |    4 +-
 drivers/scsi/scsi_debug.c                        |   24 +++---
 drivers/scsi/scsi_lib.c                          |    4 +-
 drivers/scsi/sd_dif.c                            |   12 ++--
 drivers/staging/hv/storvsc_drv.c                 |   31 +++----
 drivers/staging/rtl8192u/ieee80211/cipher.c      |    8 +-
 drivers/staging/rtl8192u/ieee80211/digest.c      |    8 +-
 drivers/staging/rtl8192u/ieee80211/internal.h    |   17 ----
 drivers/staging/rtl8192u/ieee80211/kmap_types.h  |   20 -----
 drivers/staging/rtl8192u/ieee80211/scatterwalk.c |   19 +---
 drivers/staging/zcache/zcache-main.c             |   16 ++--
 drivers/staging/zram/xvmalloc.c                  |   39 +++++-----
 drivers/staging/zram/zram_drv.c                  |   44 +++++-----
 drivers/target/target_core_transport.c           |    4 +-
 drivers/target/tcm_fc/tfc_io.c                   |   10 +--
 drivers/vhost/vhost.c                            |    4 +-
 fs/afs/fsclient.c                                |    8 +-
 fs/afs/mntpt.c                                   |    4 +-
 fs/aio.c                                         |   30 ++++----
 fs/bio-integrity.c                               |   10 +-
 fs/btrfs/compression.c                           |   12 ++--
 fs/btrfs/extent_io.c                             |   16 ++--
 fs/btrfs/file-item.c                             |    4 +-
 fs/btrfs/inode.c                                 |   26 +++---
 fs/btrfs/lzo.c                                   |    4 +-
 fs/btrfs/scrub.c                                 |    8 +-
 fs/btrfs/zlib.c                                  |    4 +-
 fs/ecryptfs/mmap.c                               |    4 +-
 fs/ecryptfs/read_write.c                         |    4 +-
 fs/exec.c                                        |    4 +-
 fs/exofs/dir.c                                   |    4 +-
 fs/ext2/dir.c                                    |    4 +-
 fs/fuse/dev.c                                    |    4 +-
 fs/fuse/file.c                                   |    4 +-
 fs/gfs2/aops.c                                   |   12 ++--
 fs/gfs2/lops.c                                   |    8 +-
 fs/gfs2/quota.c                                  |    4 +-
 fs/jbd/journal.c                                 |   12 ++--
 fs/jbd/transaction.c                             |    4 +-
 fs/jbd2/commit.c                                 |    4 +-
 fs/jbd2/journal.c                                |   12 ++--
 fs/jbd2/transaction.c                            |    4 +-
 fs/logfs/dir.c                                   |   18 ++--
 fs/logfs/readwrite.c                             |   38 +++++-----
 fs/logfs/segment.c                               |    4 +-
 fs/minix/dir.c                                   |    4 +-
 fs/namei.c                                       |    4 +-
 fs/nfs/dir.c                                     |    8 +-
 fs/nfs/nfs4proc.c                                |    4 +-
 fs/nilfs2/cpfile.c                               |   94 +++++++++++-----------
 fs/nilfs2/dat.c                                  |   38 +++++-----
 fs/nilfs2/dir.c                                  |    4 +-
 fs/nilfs2/ifile.c                                |    4 +-
 fs/nilfs2/mdt.c                                  |    4 +-
 fs/nilfs2/page.c                                 |    8 +-
 fs/nilfs2/recovery.c                             |    4 +-
 fs/nilfs2/segbuf.c                               |    4 +-
 fs/nilfs2/sufile.c                               |   68 ++++++++--------
 fs/ntfs/aops.c                                   |   20 +++---
 fs/ntfs/attrib.c                                 |   20 +++---
 fs/ntfs/file.c                                   |   16 ++--
 fs/ntfs/super.c                                  |    8 +-
 fs/ocfs2/aops.c                                  |   16 ++--
 fs/pipe.c                                        |    8 +-
 fs/reiserfs/stree.c                              |    4 +-
 fs/reiserfs/tail_conversion.c                    |    4 +-
 fs/splice.c                                      |    7 +-
 fs/squashfs/file.c                               |    8 +-
 fs/squashfs/symlink.c                            |    4 +-
 fs/ubifs/file.c                                  |    4 +-
 fs/udf/file.c                                    |    4 +-
 include/crypto/scatterwalk.h                     |   28 +------
 include/linux/bio.h                              |    8 +-
 include/linux/highmem.h                          |   79 +++++++++++++-----
 kernel/debug/kdb/kdb_support.c                   |    4 +-
 kernel/power/snapshot.c                          |   28 +++---
 lib/scatterlist.c                                |    4 +-
 lib/swiotlb.c                                    |    5 +-
 mm/bounce.c                                      |    4 +-
 mm/filemap.c                                     |    8 +-
 mm/ksm.c                                         |   12 ++--
 mm/memory.c                                      |    4 +-
 mm/shmem.c                                       |    4 +-
 mm/swapfile.c                                    |   30 ++++----
 mm/vmalloc.c                                     |    8 +-
 net/core/kmap_skb.h                              |    4 +-
 net/rds/ib_recv.c                                |    7 +-
 net/rds/info.c                                   |    6 +-
 net/rds/iw_recv.c                                |    7 +-
 net/rds/loop.c                                   |    2 +-
 net/rds/rds.h                                    |    2 +-
 net/rds/recv.c                                   |    2 +-
 net/rds/tcp_recv.c                               |   11 +--
 net/sunrpc/auth_gss/gss_krb5_wrap.c              |    4 +-
 net/sunrpc/socklib.c                             |    4 +-
 net/sunrpc/xdr.c                                 |   20 +++---
 net/sunrpc/xprtrdma/rpc_rdma.c                   |    8 +-
 security/tomoyo/domain.c                         |    4 +-
 181 files changed, 911 insertions(+), 961 deletions(-)
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/kmap_types.h

-- 
1.7.7.6

