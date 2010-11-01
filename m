Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0KAWOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:14:21 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:49230 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314Ab0KAWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:14:19 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.37-rc1 problems
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 01 Nov 2010 18:14:12 -0400
Message-ID: <web-395637137@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-rc1 probelms:

===========================

   CC [M] 
 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.o
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c: 
In function 'SetupHIFScatterSupport':
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: 
error: 'struct mmc_host' has no member named 'max_hw_segs'
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: 
error: 'struct mmc_host' has no member named 'max_hw_segs'
make[3]: 
[drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.o] 
Error 1 (ignored)
   LD [M]  drivers/staging/ath6kl/ath6kl.o
ld: 
drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.o: 
No such file: No such file or directory
make[3]: [drivers/staging/ath6kl/ath6kl.o] Error 1 
(ignored)

============================

   CC [M]  drivers/staging/solo6x10/solo6010-core.o
   CC [M]  drivers/staging/solo6x10/solo6010-i2c.o
   CC [M]  drivers/staging/solo6x10/solo6010-p2m.o
   CC [M]  drivers/staging/solo6x10/solo6010-v4l2.o
drivers/staging/solo6x10/solo6010-v4l2.c: In function 
'solo_v4l2_open':
drivers/staging/solo6x10/solo6010-v4l2.c:440: error: too 
few arguments to function 'videobuf_queue_dma_contig_init'
make[3]: [drivers/staging/solo6x10/solo6010-v4l2.o] Error 
1 (ignored)
   CC [M]  drivers/staging/solo6x10/solo6010-tw28.o
   CC [M]  drivers/staging/solo6x10/solo6010-gpio.o
   CC [M]  drivers/staging/solo6x10/solo6010-disp.o
   CC [M]  drivers/staging/solo6x10/solo6010-enc.o
   CC [M]  drivers/staging/solo6x10/solo6010-v4l2-enc.o
drivers/staging/solo6x10/solo6010-v4l2-enc.c: In function 
'solo_enc_open':
drivers/staging/solo6x10/solo6010-v4l2-enc.c:769: error: 
too few arguments to function 
'videobuf_queue_dma_contig_init'
make[3]: [drivers/staging/solo6x10/solo6010-v4l2-enc.o] 
Error 1 (ignored)
   CC [M]  drivers/staging/solo6x10/solo6010-g723.o
   LD [M]  drivers/staging/solo6x10/solo6x10.o
ld: drivers/staging/solo6x10/solo6010-v4l2.o: No such 
file: No such file or directory
make[3]: [drivers/staging/solo6x10/solo6x10.o] Error 1 
(ignored)

===============================

   CC [M]  fs/logfs/compr.o
In file included from fs/logfs/compr.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/compr.c:9:
include/linux/vmalloc.h:8: warning: empty declaration
include/linux/vmalloc.h:10: error: storage class specified 
for parameter 'vmap_lazy_unmap'
include/linux/vmalloc.h:28: warning: empty declaration
include/linux/vmalloc.h:42: error: storage class specified 
for parameter 'vm_unmap_ram'
include/linux/vmalloc.h:44: error: storage class specified 
for parameter 'vm_map_ram'
include/linux/vmalloc.h:45: error: storage class specified 
for parameter 'vm_unmap_aliases'
include/linux/vmalloc.h:48: error: storage class specified 
for parameter 'vmalloc_init'
include/linux/vmalloc.h:48: error: section attribute not 
allowed for 'vmalloc_init'
include/linux/vmalloc.h:48: warning: '__cold__' attribute 
ignored
include/linux/vmalloc.h:48: error: 
'no_instrument_function' attribute applies only to 
functions
include/linux/vmalloc.h:55: error: storage class specified 
for parameter 'vmalloc'
include/linux/vmalloc.h:56: error: storage class specified 
for parameter 'vzalloc'
include/linux/vmalloc.h:57: error: storage class specified 
for parameter 'vmalloc_user'
include/linux/vmalloc.h:58: error: storage class specified 
for parameter 'vmalloc_node'
include/linux/vmalloc.h:59: error: storage class specified 
for parameter 'vzalloc_node'
include/linux/vmalloc.h:60: error: storage class specified 
for parameter 'vmalloc_exec'
include/linux/vmalloc.h:61: error: storage class specified 
for parameter 'vmalloc_32'
include/linux/vmalloc.h:62: error: storage class specified 
for parameter 'vmalloc_32_user'
include/linux/vmalloc.h:63: error: storage class specified 
for parameter '__vmalloc'
include/linux/vmalloc.h:65: error: storage class specified 
for parameter '__vmalloc_area'
include/linux/vmalloc.h:66: error: storage class specified 
for parameter 'vfree'
include/linux/vmalloc.h:69: error: storage class specified 
for parameter 'vmap'
include/linux/vmalloc.h:70: error: storage class specified 
for parameter 'vunmap'
include/linux/vmalloc.h:73: error: storage class specified 
for parameter 'remap_vmalloc_range'
include/linux/vmalloc.h:81: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/vmalloc.h:86: error: storage class specified 
for parameter 'get_vm_area'
include/linux/vmalloc.h:88: error: storage class specified 
for parameter 'get_vm_area_caller'
include/linux/vmalloc.h:90: error: storage class specified 
for parameter '__get_vm_area'
include/linux/vmalloc.h:94: error: storage class specified 
for parameter '__get_vm_area_caller'
include/linux/vmalloc.h:97: error: storage class specified 
for parameter 'get_vm_area_node'
include/linux/vmalloc.h:98: error: storage class specified 
for parameter 'remove_vm_area'
include/linux/vmalloc.h:101: error: storage class 
specified for parameter 'map_vm_area'
include/linux/vmalloc.h:103: error: storage class 
specified for parameter 'map_kernel_range_noflush'
include/linux/vmalloc.h:104: error: storage class 
specified for parameter 'unmap_kernel_range_noflush'
include/linux/vmalloc.h:105: error: storage class 
specified for parameter 'unmap_kernel_range'
include/linux/vmalloc.h:108: error: storage class 
specified for parameter 'alloc_vm_area'
include/linux/vmalloc.h:109: error: storage class 
specified for parameter 'free_vm_area'
include/linux/vmalloc.h:112: error: storage class 
specified for parameter 'vread'
include/linux/vmalloc.h:113: error: storage class 
specified for parameter 'vwrite'
include/linux/vmalloc.h:118: error: storage class 
specified for parameter 'vmlist_lock'
include/linux/vmalloc.h:119: error: storage class 
specified for parameter 'vmlist'
include/linux/vmalloc.h:120: error: storage class 
specified for parameter 'vm_area_register_early'
include/linux/vmalloc.h:120: error: section attribute not 
allowed for 'vm_area_register_early'
include/linux/vmalloc.h:120: warning: '__cold__' attribute 
ignored
include/linux/vmalloc.h:120: error: 
'no_instrument_function' attribute applies only to 
functions
In file included from include/linux/zlib.h:33,
                  from fs/logfs/compr.c:10:
include/linux/zconf.h:52: error: storage class specified 
for parameter 'Byte'
include/linux/zconf.h:53: error: storage class specified 
for parameter 'uInt'
include/linux/zconf.h:54: error: storage class specified 
for parameter 'uLong'
include/linux/zconf.h:55: error: storage class specified 
for parameter 'voidp'
In file included from fs/logfs/compr.c:10:
include/linux/zlib.h:82: warning: empty declaration
include/linux/zlib.h:85: error: expected ':', ',', ';', 
'}' or '__attribute__' before '*' token
include/linux/zlib.h:101: error: storage class specified 
for parameter 'z_stream'
include/linux/zlib.h:103: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '*' token
include/linux/zlib.h:182: error: storage class specified 
for parameter 'zlib_deflate_workspacesize'
include/linux/zlib.h:212: error: expected ')' before 
'strm'
include/linux/zlib.h:290: error: expected ')' before 
'strm'
include/linux/zlib.h:304: error: storage class specified 
for parameter 'zlib_inflate_workspacesize'
include/linux/zlib.h:332: error: expected ')' before 
'strm'
include/linux/zlib.h:431: error: expected ')' before 
'strm'
include/linux/zlib.h:550: error: expected ')' before 
'strm'
include/linux/zlib.h:562: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/zlib.h:629: error: expected ')' before 
'strm'
include/linux/zlib.h:668: error: expected ')' before 
'strm'
include/linux/zlib.h:678: error: expected ')' before '*' 
token
include/linux/zlib.h:693: error: expected ')' before 
'strm'
include/linux/zlib.h:696: error: expected ')' before 
'strm'
include/linux/zlib.h:699: warning: empty declaration
include/linux/zlib.h:704: error: storage class specified 
for parameter 'zlib_inflate_blob'
fs/logfs/compr.c:14: error: storage class specified for 
parameter 'compr_mutex'
fs/logfs/compr.c:14: error: parameter 'compr_mutex' is 
initialized
fs/logfs/compr.c:15: error: storage class specified for 
parameter 'stream'
fs/logfs/compr.c:18: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/compr.c:52: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/compr.c:83: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/compr.c:93: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/compr.c:95: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/compr.c:95: error: expected '{' at end of input
fs/logfs/compr.c:95: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/compr.o] Error 1 (ignored)
   CC [M]  fs/logfs/dir.o
In file included from fs/logfs/dir.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/dir.c:9:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/dir.c:9:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/dir.c:9:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/dir.c:9:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/dir.c:9:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
fs/logfs/dir.c:68: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/dir.c:73: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/dir.c:78: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/dir.c:85: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/dir.c:99: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/dir.c:135: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:158: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:197: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:207: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:214: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:265: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:273: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:286: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:322: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:346: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:353: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:383: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:391: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:430: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:488: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:508: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:524: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:541: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:559: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:565: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:581: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:597: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:616: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:664: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:688: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:750: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:759: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/dir.c:808: error: parameter 'logfs_symlink_iops' 
is initialized
fs/logfs/dir.c:808: error: redefinition of parameter 
'logfs_symlink_iops'
fs/logfs/logfs.h:498: error: previous definition of 
'logfs_symlink_iops' was here
fs/logfs/dir.c:813: error: parameter 'logfs_dir_iops' is 
initialized
fs/logfs/dir.c:813: error: redefinition of parameter 
'logfs_dir_iops'
fs/logfs/logfs.h:499: error: previous definition of 
'logfs_dir_iops' was here
fs/logfs/dir.c:814: error: 'logfs_create' undeclared 
(first use in this function)
fs/logfs/dir.c:814: error: (Each undeclared identifier is 
reported only once
fs/logfs/dir.c:814: error: for each function it appears 
in.)
fs/logfs/dir.c:815: error: 'logfs_link' undeclared (first 
use in this function)
fs/logfs/dir.c:816: error: 'logfs_lookup' undeclared 
(first use in this function)
fs/logfs/dir.c:817: error: 'logfs_mkdir' undeclared (first 
use in this function)
fs/logfs/dir.c:818: error: 'logfs_mknod' undeclared (first 
use in this function)
fs/logfs/dir.c:819: error: 'logfs_rename' undeclared 
(first use in this function)
fs/logfs/dir.c:820: error: 'logfs_rmdir' undeclared (first 
use in this function)
fs/logfs/dir.c:821: error: 'logfs_permission' undeclared 
(first use in this function)
fs/logfs/dir.c:822: error: 'logfs_symlink' undeclared 
(first use in this function)
fs/logfs/dir.c:823: error: 'logfs_unlink' undeclared 
(first use in this function)
fs/logfs/dir.c:825: error: parameter 'logfs_dir_fops' is 
initialized
fs/logfs/dir.c:825: error: redefinition of parameter 
'logfs_dir_fops'
fs/logfs/logfs.h:500: error: previous definition of 
'logfs_dir_fops' was here
fs/logfs/dir.c:828: error: 'logfs_readdir' undeclared 
(first use in this function)
fs/logfs/dir.c:831: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/dir.c:831: error: expected '{' at end of input
fs/logfs/dir.c:831: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/dir.o] Error 1 (ignored)
   CC [M]  fs/logfs/file.o
In file included from fs/logfs/file.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/file.c:10:
include/linux/writeback.h:10: warning: empty declaration
include/linux/writeback.h:12: error: storage class 
specified for parameter 'inode_lock'
include/linux/writeback.h:17: warning: empty declaration
include/linux/writeback.h:27: warning: empty declaration
include/linux/writeback.h:58: warning: empty declaration
include/linux/writeback.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:77: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:98: error: storage class 
specified for parameter 'dirty_background_ratio'
include/linux/writeback.h:99: error: storage class 
specified for parameter 'dirty_background_bytes'
include/linux/writeback.h:100: error: storage class 
specified for parameter 'vm_dirty_ratio'
include/linux/writeback.h:101: error: storage class 
specified for parameter 'vm_dirty_bytes'
include/linux/writeback.h:102: error: storage class 
specified for parameter 'dirty_writeback_interval'
include/linux/writeback.h:103: error: storage class 
specified for parameter 'dirty_expire_interval'
include/linux/writeback.h:104: error: storage class 
specified for parameter 'vm_highmem_is_dirtyable'
include/linux/writeback.h:105: error: storage class 
specified for parameter 'block_dump'
include/linux/writeback.h:106: error: storage class 
specified for parameter 'laptop_mode'
include/linux/writeback.h:108: error: storage class 
specified for parameter 'determine_dirtyable_memory'
include/linux/writeback.h:112: error: storage class 
specified for parameter 'dirty_background_ratio_handler'
include/linux/writeback.h:115: error: storage class 
specified for parameter 'dirty_background_bytes_handler'
include/linux/writeback.h:118: error: storage class 
specified for parameter 'dirty_ratio_handler'
include/linux/writeback.h:121: error: storage class 
specified for parameter 'dirty_bytes_handler'
include/linux/writeback.h:123: warning: empty declaration
include/linux/writeback.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:142: error: storage class 
specified for parameter 'writepage_t'
include/linux/writeback.h:149: error: expected declaration 
specifiers or '...' before 'writepage_t'
include/linux/writeback.h:154: error: redefinition of 
parameter 'tag_pages_for_writeback'
include/linux/writeback.h:146: error: previous definition 
of 'tag_pages_for_writeback' was here
include/linux/writeback.h:158: error: storage class 
specified for parameter 'nr_pdflush_threads'
fs/logfs/file.c:15: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:41: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:83: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:97: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:104: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:118: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:163: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:179: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:185: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:223: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:231: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/file.c:250: error: parameter 'logfs_reg_iops' is 
initialized
fs/logfs/file.c:250: error: redefinition of parameter 
'logfs_reg_iops'
fs/logfs/logfs.h:504: error: previous definition of 
'logfs_reg_iops' was here
fs/logfs/file.c:251: error: 'logfs_setattr' undeclared 
(first use in this function)
fs/logfs/file.c:251: error: (Each undeclared identifier is 
reported only once
fs/logfs/file.c:251: error: for each function it appears 
in.)
fs/logfs/file.c:254: error: parameter 'logfs_reg_fops' is 
initialized
fs/logfs/file.c:254: error: redefinition of parameter 
'logfs_reg_fops'
fs/logfs/logfs.h:505: error: previous definition of 
'logfs_reg_fops' was here
fs/logfs/file.c:266: error: parameter 'logfs_reg_aops' is 
initialized
fs/logfs/file.c:266: error: redefinition of parameter 
'logfs_reg_aops'
fs/logfs/logfs.h:506: error: previous definition of 
'logfs_reg_aops' was here
fs/logfs/file.c:267: error: 'logfs_invalidatepage' 
undeclared (first use in this function)
fs/logfs/file.c:269: error: 'logfs_releasepage' undeclared 
(first use in this function)
fs/logfs/file.c:271: error: 'logfs_writepage' undeclared 
(first use in this function)
fs/logfs/file.c:272: warning: initialization from 
incompatible pointer type
fs/logfs/file.c:273: error: 'logfs_write_begin' undeclared 
(first use in this function)
fs/logfs/file.c:274: error: 'logfs_write_end' undeclared 
(first use in this function)
fs/logfs/file.c:275: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/file.c:275: error: expected '{' at end of input
fs/logfs/file.c:275: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/file.o] Error 1 (ignored)
   CC [M]  fs/logfs/gc.o
In file included from fs/logfs/gc.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/gc.c:10:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/gc.c:10:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/gc.c:10:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/gc.c:10:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/gc.c:10:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
fs/logfs/gc.c:32: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:40: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:66: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:88: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:98: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:115: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:126: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:184: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:219: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:227: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:235: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:269: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:300: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:319: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:331: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:349: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:365: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:385: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:412: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:423: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:457: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:525: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:536: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:579: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:616: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:632: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:664: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:677: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:685: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:701: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:714: error: expected '=', ',', ';', 'asm' or 
'__attribute__' before '{' token
fs/logfs/gc.c:732: error: old-style parameter declarations 
in prototyped function definition
fs/logfs/gc.c:732: error: expected '{' at end of input
fs/logfs/gc.c:732: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/gc.o] Error 1 (ignored)
   CC [M]  fs/logfs/inode.o
In file included from fs/logfs/inode.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/inode.c:9:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/inode.c:9:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/inode.c:9:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/inode.c:9:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/inode.c:9:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
In file included from fs/logfs/inode.c:10:
include/linux/writeback.h:10: warning: empty declaration
include/linux/writeback.h:12: error: storage class 
specified for parameter 'inode_lock'
include/linux/writeback.h:17: warning: empty declaration
include/linux/writeback.h:27: warning: empty declaration
include/linux/writeback.h:58: warning: empty declaration
include/linux/writeback.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:77: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:98: error: storage class 
specified for parameter 'dirty_background_ratio'
include/linux/writeback.h:99: error: storage class 
specified for parameter 'dirty_background_bytes'
include/linux/writeback.h:100: error: storage class 
specified for parameter 'vm_dirty_ratio'
include/linux/writeback.h:101: error: storage class 
specified for parameter 'vm_dirty_bytes'
include/linux/writeback.h:102: error: storage class 
specified for parameter 'dirty_writeback_interval'
include/linux/writeback.h:103: error: storage class 
specified for parameter 'dirty_expire_interval'
include/linux/writeback.h:104: error: storage class 
specified for parameter 'vm_highmem_is_dirtyable'
include/linux/writeback.h:105: error: storage class 
specified for parameter 'block_dump'
include/linux/writeback.h:106: error: storage class 
specified for parameter 'laptop_mode'
include/linux/writeback.h:108: error: storage class 
specified for parameter 'determine_dirtyable_memory'
include/linux/writeback.h:112: error: storage class 
specified for parameter 'dirty_background_ratio_handler'
include/linux/writeback.h:115: error: storage class 
specified for parameter 'dirty_background_bytes_handler'
include/linux/writeback.h:118: error: storage class 
specified for parameter 'dirty_ratio_handler'
include/linux/writeback.h:121: error: storage class 
specified for parameter 'dirty_bytes_handler'
include/linux/writeback.h:123: warning: empty declaration
include/linux/writeback.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:142: error: storage class 
specified for parameter 'writepage_t'
include/linux/writeback.h:149: error: expected declaration 
specifiers or '...' before 'writepage_t'
include/linux/writeback.h:154: error: redefinition of 
parameter 'tag_pages_for_writeback'
include/linux/writeback.h:146: error: previous definition 
of 'tag_pages_for_writeback' was here
include/linux/writeback.h:158: error: storage class 
specified for parameter 'nr_pdflush_threads'
In file included from fs/logfs/inode.c:11:
include/linux/backing-dev.h:21: warning: empty declaration
include/linux/backing-dev.h:22: warning: empty declaration
include/linux/backing-dev.h:23: warning: empty declaration
include/linux/backing-dev.h:28: warning: empty declaration
include/linux/backing-dev.h:38: error: storage class 
specified for parameter 'congested_fn'
include/linux/backing-dev.h:40: warning: empty declaration
include/linux/backing-dev.h:48: warning: empty declaration
include/linux/backing-dev.h:67: error: expected 
specifier-qualifier-list before 'congested_fn'
include/linux/backing-dev.h:62: warning: empty declaration
include/linux/backing-dev.h:112: error: storage class 
specified for parameter 'bdi_lock'
include/linux/backing-dev.h:113: error: storage class 
specified for parameter 'bdi_list'
include/linux/backing-dev.h:114: error: storage class 
specified for parameter 'bdi_pending_list'
include/linux/backing-dev.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:131: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:147: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:153: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:163: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:169: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:175: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:186: error: storage class 
specified for parameter 'bdi_writeout_inc'
include/linux/backing-dev.h:192: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:252: error: storage class 
specified for parameter 'default_backing_dev_info'
include/linux/backing-dev.h:253: error: storage class 
specified for parameter 'noop_backing_dev_info'
include/linux/backing-dev.h:259: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:266: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:271: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:276: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:281: warning: empty 
declaration
include/linux/backing-dev.h:292: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:297: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:302: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:309: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:314: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:319: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:324: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:329: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:334: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:341: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:347: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
fs/logfs/inode.c:49: error: storage class specified for 
parameter 'logfs_inode_cache'
fs/logfs/inode.c:51: error: storage class specified for 
parameter 'logfs_inode_lock'
fs/logfs/inode.c:51: error: parameter 'logfs_inode_lock' 
is initialized
fs/logfs/inode.c:54: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:82: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:110: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:121: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:145: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:154: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:166: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:181: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:206: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:242: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:258: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:276: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:291: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:303: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:322: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:347: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:360: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:366: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:374: error: parameter 
'logfs_super_operations' is initialized
fs/logfs/inode.c:374: error: redefinition of parameter 
'logfs_super_operations'
fs/logfs/logfs.h:519: error: previous definition of 
'logfs_super_operations' was here
fs/logfs/inode.c:375: error: 'logfs_alloc_inode' 
undeclared (first use in this function)
fs/logfs/inode.c:375: error: (Each undeclared identifier 
is reported only once
fs/logfs/inode.c:375: error: for each function it appears 
in.)
fs/logfs/inode.c:376: error: 'logfs_destroy_inode' 
undeclared (first use in this function)
fs/logfs/inode.c:378: error: 'logfs_drop_inode' undeclared 
(first use in this function)
fs/logfs/inode.c:379: error: 'logfs_put_super' undeclared 
(first use in this function)
fs/logfs/inode.c:380: error: 'logfs_write_inode' 
undeclared (first use in this function)
fs/logfs/inode.c:382: error: 'logfs_sync_fs' undeclared 
(first use in this function)
fs/logfs/inode.c:386: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:396: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/inode.c:398: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/inode.c:398: error: expected '{' at end of input
fs/logfs/inode.c:398: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/inode.o] Error 1 (ignored)
   CC [M]  fs/logfs/journal.o
In file included from fs/logfs/journal.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/journal.c:9:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/journal.c:9:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/journal.c:9:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/journal.c:9:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/journal.c:9:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
fs/logfs/journal.c:12: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:51: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:75: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:89: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:107: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:116: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:141: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:161: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:186: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:213: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:223: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:261: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:332: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:359: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:383: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:389: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:423: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:439: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:446: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:452: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:466: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:492: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:517: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:537: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:555: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:576: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:595: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:605: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:631: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:653: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:677: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:688: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:711: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:736: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:807: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:848: error: storage class specified for 
parameter 'journal_area_ops'
fs/logfs/journal.c:848: error: parameter 
'journal_area_ops' is initialized
fs/logfs/journal.c:849: error: 'journal_get_free_segment' 
undeclared (first use in this function)
fs/logfs/journal.c:849: error: (Each undeclared identifier 
is reported only once
fs/logfs/journal.c:849: error: for each function it 
appears in.)
fs/logfs/journal.c:850: error: 'journal_get_erase_count' 
undeclared (first use in this function)
fs/logfs/journal.c:851: error: 'journal_erase_segment' 
undeclared (first use in this function)
fs/logfs/journal.c:855: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:888: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/journal.c:895: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/journal.c:895: error: expected '{' at end of 
input
fs/logfs/journal.c:895: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/journal.o] Error 1 (ignored)
   CC [M]  fs/logfs/readwrite.o
In file included from fs/logfs/readwrite.c:19:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/readwrite.c:21:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/readwrite.c:21:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/readwrite.c:21:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/readwrite.c:21:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/readwrite.c:21:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
fs/logfs/readwrite.c:24: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:45: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:63: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:68: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:82: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:105: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:110: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:115: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:151: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:188: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:198: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:206: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:223: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:249: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:265: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:278: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:284: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:290: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:314: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:339: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:345: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:352: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:360: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:368: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:378: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:384: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:392: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:419: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:440: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:445: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:465: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:507: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:532: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:546: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:553: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:562: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:569: error: storage class specified 
for parameter 'inode_block_ops'
fs/logfs/readwrite.c:569: error: parameter 
'inode_block_ops' is initialized
fs/logfs/readwrite.c:570: error: 'inode_write_block' 
undeclared (first use in this function)
fs/logfs/readwrite.c:570: error: (Each undeclared 
identifier is reported only once
fs/logfs/readwrite.c:570: error: for each function it 
appears in.)
fs/logfs/readwrite.c:571: error: 'inode_free_block' 
undeclared (first use in this function)
fs/logfs/readwrite.c:572: error: 'inode_write_alias' 
undeclared (first use in this function)
fs/logfs/readwrite.c:575: error: parameter 
'indirect_block_ops' is initialized
fs/logfs/readwrite.c:575: error: redefinition of parameter 
'indirect_block_ops'
fs/logfs/logfs.h:580: error: previous definition of 
'indirect_block_ops' was here
fs/logfs/readwrite.c:576: error: 'indirect_write_block' 
undeclared (first use in this function)
fs/logfs/readwrite.c:577: error: 'indirect_free_block' 
undeclared (first use in this function)
fs/logfs/readwrite.c:578: error: 'indirect_write_alias' 
undeclared (first use in this function)
fs/logfs/readwrite.c:583: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:599: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:614: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:642: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:660: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:676: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:694: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:705: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:711: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:725: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:763: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:772: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:805: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:814: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:824: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:882: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:911: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:939: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:951: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:957: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:985: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1002: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1027: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1058: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1077: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1096: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1129: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1202: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1206: warning: empty declaration
fs/logfs/readwrite.c:1213: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1234: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1270: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1299: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1321: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1336: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1372: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1393: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1413: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1463: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1490: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1496: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1504: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1535: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1560: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1571: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1583: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1603: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1636: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1659: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1683: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1719: error: storage class specified 
for parameter '__logfs_step'
fs/logfs/readwrite.c:1719: error: parameter '__logfs_step' 
is initialized
fs/logfs/readwrite.c:1720: warning: initialization makes 
pointer from integer without a cast
fs/logfs/readwrite.c:1721: warning: excess elements in 
scalar initializer
fs/logfs/readwrite.c:1721: warning: (near initialization 
for '__logfs_step')
fs/logfs/readwrite.c:1722: warning: excess elements in 
scalar initializer
fs/logfs/readwrite.c:1722: warning: (near initialization 
for '__logfs_step')
fs/logfs/readwrite.c:1723: warning: excess elements in 
scalar initializer
fs/logfs/readwrite.c:1723: warning: (near initialization 
for '__logfs_step')
fs/logfs/readwrite.c:1726: error: storage class specified 
for parameter '__logfs_start_index'
fs/logfs/readwrite.c:1726: error: parameter 
'__logfs_start_index' is initialized
fs/logfs/readwrite.c:1727: warning: initialization makes 
pointer from integer without a cast
fs/logfs/readwrite.c:1728: warning: excess elements in 
scalar initializer
fs/logfs/readwrite.c:1728: warning: (near initialization 
for '__logfs_start_index')
fs/logfs/readwrite.c:1729: warning: excess elements in 
scalar initializer
fs/logfs/readwrite.c:1729: warning: (near initialization 
for '__logfs_start_index')
fs/logfs/readwrite.c:1731: warning: excess elements in 
scalar initializer
fs/logfs/readwrite.c:1731: warning: (near initialization 
for '__logfs_start_index')
fs/logfs/readwrite.c:1734: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1739: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1744: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1749: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1757: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1810: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1838: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1859: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1889: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1909: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1929: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1957: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:1976: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2005: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2036: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2044: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2049: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2058: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2069: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2075: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2082: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2087: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2093: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2099: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2107: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2118: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2143: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2179: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2216: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2242: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2254: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2269: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/readwrite.c:2274: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/readwrite.c:2274: error: expected '{' at end of 
input
fs/logfs/readwrite.c:2274: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/readwrite.o] Error 1 (ignored)
   CC [M]  fs/logfs/segment.o
In file included from fs/logfs/segment.c:12:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/segment.c:13:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/segment.c:13:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/segment.c:13:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/segment.c:13:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/segment.c:13:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
fs/logfs/segment.c:16: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:30: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:40: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:54: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:72: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:101: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:119: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:145: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:158: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:167: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:176: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:189: error: storage class specified for 
parameter 'btree_block_ops'
fs/logfs/segment.c:189: error: parameter 'btree_block_ops' 
is initialized
fs/logfs/segment.c:192: error: 'btree_write_alias' 
undeclared (first use in this function)
fs/logfs/segment.c:192: error: (Each undeclared identifier 
is reported only once
fs/logfs/segment.c:192: error: for each function it 
appears in.)
fs/logfs/segment.c:197: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:243: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:269: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:284: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:326: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:354: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:390: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:419: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:447: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:466: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:501: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:506: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:550: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:639: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:661: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:693: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:711: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:749: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:765: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:778: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:791: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:804: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:831: error: storage class specified for 
parameter 'ostore_area_ops'
fs/logfs/segment.c:831: error: parameter 'ostore_area_ops' 
is initialized
fs/logfs/segment.c:832: error: 'ostore_get_free_segment' 
undeclared (first use in this function)
fs/logfs/segment.c:833: error: 'ostore_get_erase_count' 
undeclared (first use in this function)
fs/logfs/segment.c:834: error: 'ostore_erase_segment' 
undeclared (first use in this function)
fs/logfs/segment.c:838: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:845: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:857: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:862: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:867: error: storage class specified for 
parameter 'mapping_aops'
fs/logfs/segment.c:867: error: parameter 'mapping_aops' is 
initialized
fs/logfs/segment.c:868: error: 'map_invalidatepage' 
undeclared (first use in this function)
fs/logfs/segment.c:869: error: 'map_releasepage' 
undeclared (first use in this function)
fs/logfs/segment.c:874: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:891: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:924: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/segment.c:932: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/segment.c:932: error: expected '{' at end of 
input
fs/logfs/segment.c:932: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/segment.o] Error 1 (ignored)
   CC [M]  fs/logfs/super.o
In file included from fs/logfs/super.c:12:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from include/linux/ioprio.h:5,
                  from include/linux/bio.h:25,
                  from fs/logfs/super.c:13:
include/linux/iocontext.h:7: warning: empty declaration
include/linux/iocontext.h:8: warning: empty declaration
include/linux/iocontext.h:34: warning: empty declaration
include/linux/iocontext.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/iocontext.h:73: warning: empty declaration
In file included from include/linux/bio.h:25,
                  from fs/logfs/super.c:13:
include/linux/ioprio.h:26: warning: empty declaration
include/linux/ioprio.h:38: warning: empty declaration
include/linux/ioprio.h:50: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:58: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:66: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:75: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:87: error: storage class specified 
for parameter 'ioprio_best'
include/linux/ioprio.h:89: error: storage class specified 
for parameter 'set_task_ioprio'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:44,
                  from include/linux/bio.h:29,
                  from fs/logfs/super.c:13:
include/xen/xen.h:4: warning: empty declaration
In file included from include/linux/bio.h:29,
                  from fs/logfs/super.c:13:
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:56: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:57: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:58: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:60: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:61: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:62: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:64: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:65: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:66: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:68: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:69: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:70: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:93: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:104: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:134: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:152: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:167: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:196: 
error: storage class specified for parameter 
'ioremap_nocache'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:197: 
error: storage class specified for parameter 
'ioremap_cache'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:199: 
error: storage class specified for parameter 
'ioremap_prot'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:205: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:209: 
error: storage class specified for parameter 'iounmap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:211: 
error: storage class specified for parameter 
'set_iounmap_nonlazy'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:215,
                  from include/linux/bio.h:29,
                  from fs/logfs/super.c:13:
include/asm-generic/iomap.h:28: error: storage class 
specified for parameter 'ioread8'
include/asm-generic/iomap.h:29: error: storage class 
specified for parameter 'ioread16'
include/asm-generic/iomap.h:30: error: storage class 
specified for parameter 'ioread16be'
include/asm-generic/iomap.h:31: error: storage class 
specified for parameter 'ioread32'
include/asm-generic/iomap.h:32: error: storage class 
specified for parameter 'ioread32be'
include/asm-generic/iomap.h:34: error: storage class 
specified for parameter 'iowrite8'
include/asm-generic/iomap.h:35: error: storage class 
specified for parameter 'iowrite16'
include/asm-generic/iomap.h:36: error: storage class 
specified for parameter 'iowrite16be'
include/asm-generic/iomap.h:37: error: storage class 
specified for parameter 'iowrite32'
include/asm-generic/iomap.h:38: error: storage class 
specified for parameter 'iowrite32be'
include/asm-generic/iomap.h:51: error: storage class 
specified for parameter 'ioread8_rep'
include/asm-generic/iomap.h:52: error: storage class 
specified for parameter 'ioread16_rep'
include/asm-generic/iomap.h:53: error: storage class 
specified for parameter 'ioread32_rep'
include/asm-generic/iomap.h:55: error: storage class 
specified for parameter 'iowrite8_rep'
include/asm-generic/iomap.h:56: error: storage class 
specified for parameter 'iowrite16_rep'
include/asm-generic/iomap.h:57: error: storage class 
specified for parameter 'iowrite32_rep'
include/asm-generic/iomap.h:60: error: storage class 
specified for parameter 'ioport_map'
include/asm-generic/iomap.h:61: error: storage class 
specified for parameter 'ioport_unmap'
include/asm-generic/iomap.h:68: warning: empty declaration
include/asm-generic/iomap.h:69: error: storage class 
specified for parameter 'pci_iomap'
include/asm-generic/iomap.h:70: error: storage class 
specified for parameter 'pci_iounmap'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:217,
                  from include/linux/bio.h:29,
                  from fs/logfs/super.c:13:
include/linux/vmalloc.h:8: warning: empty declaration
include/linux/vmalloc.h:10: error: storage class specified 
for parameter 'vmap_lazy_unmap'
include/linux/vmalloc.h:28: warning: empty declaration
include/linux/vmalloc.h:42: error: storage class specified 
for parameter 'vm_unmap_ram'
include/linux/vmalloc.h:44: error: storage class specified 
for parameter 'vm_map_ram'
include/linux/vmalloc.h:45: error: storage class specified 
for parameter 'vm_unmap_aliases'
include/linux/vmalloc.h:48: error: storage class specified 
for parameter 'vmalloc_init'
include/linux/vmalloc.h:48: error: section attribute not 
allowed for 'vmalloc_init'
include/linux/vmalloc.h:48: warning: '__cold__' attribute 
ignored
include/linux/vmalloc.h:48: error: 
'no_instrument_function' attribute applies only to 
functions
include/linux/vmalloc.h:55: error: storage class specified 
for parameter 'vmalloc'
include/linux/vmalloc.h:56: error: storage class specified 
for parameter 'vzalloc'
include/linux/vmalloc.h:57: error: storage class specified 
for parameter 'vmalloc_user'
include/linux/vmalloc.h:58: error: storage class specified 
for parameter 'vmalloc_node'
include/linux/vmalloc.h:59: error: storage class specified 
for parameter 'vzalloc_node'
include/linux/vmalloc.h:60: error: storage class specified 
for parameter 'vmalloc_exec'
include/linux/vmalloc.h:61: error: storage class specified 
for parameter 'vmalloc_32'
include/linux/vmalloc.h:62: error: storage class specified 
for parameter 'vmalloc_32_user'
include/linux/vmalloc.h:63: error: storage class specified 
for parameter '__vmalloc'
include/linux/vmalloc.h:65: error: storage class specified 
for parameter '__vmalloc_area'
include/linux/vmalloc.h:66: error: storage class specified 
for parameter 'vfree'
include/linux/vmalloc.h:69: error: storage class specified 
for parameter 'vmap'
include/linux/vmalloc.h:70: error: storage class specified 
for parameter 'vunmap'
include/linux/vmalloc.h:73: error: storage class specified 
for parameter 'remap_vmalloc_range'
include/linux/vmalloc.h:81: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/vmalloc.h:86: error: storage class specified 
for parameter 'get_vm_area'
include/linux/vmalloc.h:88: error: storage class specified 
for parameter 'get_vm_area_caller'
include/linux/vmalloc.h:90: error: storage class specified 
for parameter '__get_vm_area'
include/linux/vmalloc.h:94: error: storage class specified 
for parameter '__get_vm_area_caller'
include/linux/vmalloc.h:97: error: storage class specified 
for parameter 'get_vm_area_node'
include/linux/vmalloc.h:98: error: storage class specified 
for parameter 'remove_vm_area'
include/linux/vmalloc.h:101: error: storage class 
specified for parameter 'map_vm_area'
include/linux/vmalloc.h:103: error: storage class 
specified for parameter 'map_kernel_range_noflush'
include/linux/vmalloc.h:104: error: storage class 
specified for parameter 'unmap_kernel_range_noflush'
include/linux/vmalloc.h:105: error: storage class 
specified for parameter 'unmap_kernel_range'
include/linux/vmalloc.h:108: error: storage class 
specified for parameter 'alloc_vm_area'
include/linux/vmalloc.h:109: error: storage class 
specified for parameter 'free_vm_area'
include/linux/vmalloc.h:112: error: storage class 
specified for parameter 'vread'
include/linux/vmalloc.h:113: error: storage class 
specified for parameter 'vwrite'
include/linux/vmalloc.h:118: error: storage class 
specified for parameter 'vmlist_lock'
include/linux/vmalloc.h:119: error: storage class 
specified for parameter 'vmlist'
include/linux/vmalloc.h:120: error: storage class 
specified for parameter 'vm_area_register_early'
include/linux/vmalloc.h:120: error: section attribute not 
allowed for 'vm_area_register_early'
include/linux/vmalloc.h:120: warning: '__cold__' attribute 
ignored
include/linux/vmalloc.h:120: error: 
'no_instrument_function' attribute applies only to 
functions
In file included from include/linux/bio.h:29,
                  from fs/logfs/super.c:13:
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:226: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:232: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:238: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:261: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:269: 
error: storage class specified for parameter 
'native_io_delay'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:271: 
error: storage class specified for parameter 
'io_delay_type'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:272: 
error: storage class specified for parameter 
'io_delay_init'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:334: 
error: storage class specified for parameter 
'xlate_dev_mem_ptr'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:335: 
error: storage class specified for parameter 
'unxlate_dev_mem_ptr'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:338: 
error: storage class specified for parameter 
'ioremap_change_attr'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:339: 
error: storage class specified for parameter 'ioremap_wc'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:346: 
error: storage class specified for parameter 
'early_ioremap_init'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:347: 
error: storage class specified for parameter 
'early_ioremap_reset'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:349: 
error: storage class specified for parameter 
'early_ioremap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:351: 
error: storage class specified for parameter 
'early_memremap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:352: 
error: storage class specified for parameter 
'early_iounmap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:353: 
error: storage class specified for parameter 
'fixup_early_ioremap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:354: 
error: storage class specified for parameter 
'is_early_ioremap_ptep'
In file included from fs/logfs/super.c:13:
include/linux/bio.h:75: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:83: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:91: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:173: warning: empty declaration
include/linux/bio.h:202: warning: empty declaration
include/linux/bio.h:212: error: storage class specified 
for parameter 'bio_split'
include/linux/bio.h:213: error: storage class specified 
for parameter 'bio_pair_release'
include/linux/bio.h:215: error: storage class specified 
for parameter 'bioset_create'
include/linux/bio.h:216: error: storage class specified 
for parameter 'bioset_free'
include/linux/bio.h:218: error: storage class specified 
for parameter 'bio_alloc'
include/linux/bio.h:219: error: storage class specified 
for parameter 'bio_kmalloc'
include/linux/bio.h:220: error: storage class specified 
for parameter 'bio_alloc_bioset'
include/linux/bio.h:221: error: storage class specified 
for parameter 'bio_put'
include/linux/bio.h:222: error: storage class specified 
for parameter 'bio_free'
include/linux/bio.h:224: error: storage class specified 
for parameter 'bio_endio'
include/linux/bio.h:225: warning: empty declaration
include/linux/bio.h:226: error: storage class specified 
for parameter 'bio_phys_segments'
include/linux/bio.h:228: error: storage class specified 
for parameter '__bio_clone'
include/linux/bio.h:229: error: storage class specified 
for parameter 'bio_clone'
include/linux/bio.h:231: error: storage class specified 
for parameter 'bio_init'
include/linux/bio.h:233: error: storage class specified 
for parameter 'bio_add_page'
include/linux/bio.h:235: error: storage class specified 
for parameter 'bio_add_pc_page'
include/linux/bio.h:236: error: storage class specified 
for parameter 'bio_get_nr_vecs'
include/linux/bio.h:237: error: storage class specified 
for parameter 'bio_sector_offset'
include/linux/bio.h:239: error: storage class specified 
for parameter 'bio_map_user'
include/linux/bio.h:240: warning: empty declaration
include/linux/bio.h:241: warning: empty declaration
include/linux/bio.h:244: error: storage class specified 
for parameter 'bio_map_user_iov'
include/linux/bio.h:245: error: storage class specified 
for parameter 'bio_unmap_user'
include/linux/bio.h:247: error: storage class specified 
for parameter 'bio_map_kern'
include/linux/bio.h:249: error: storage class specified 
for parameter 'bio_copy_kern'
include/linux/bio.h:250: error: storage class specified 
for parameter 'bio_set_pages_dirty'
include/linux/bio.h:251: error: storage class specified 
for parameter 'bio_check_pages_dirty'
include/linux/bio.h:260: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:265: error: storage class specified 
for parameter 'bio_copy_user'
include/linux/bio.h:268: error: storage class specified 
for parameter 'bio_copy_user_iov'
include/linux/bio.h:269: error: storage class specified 
for parameter 'bio_uncopy_user'
include/linux/bio.h:271: error: storage class specified 
for parameter 'bvec_alloc_bs'
include/linux/bio.h:272: error: storage class specified 
for parameter 'bvec_free_bs'
include/linux/bio.h:273: error: storage class specified 
for parameter 'bvec_nr_vecs'
include/linux/bio.h:279: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:293: warning: empty declaration
include/linux/bio.h:304: warning: empty declaration
include/linux/bio.h:310: error: storage class specified 
for parameter 'fs_bio_set'
include/linux/bio.h:311: error: storage class specified 
for parameter 'bvec_slabs'
include/linux/bio.h:311: error: section attribute not 
allowed for 'bvec_slabs'
include/linux/bio.h:325: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:341: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:362: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:375: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:386: warning: empty declaration
include/linux/bio.h:392: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:397: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:405: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:416: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:428: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:438: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:452: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:465: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:470: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:485: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:512: error: storage class specified 
for parameter 'bio_integrity_alloc_bioset'
include/linux/bio.h:513: error: storage class specified 
for parameter 'bio_integrity_alloc'
include/linux/bio.h:514: error: storage class specified 
for parameter 'bio_integrity_free'
include/linux/bio.h:515: error: storage class specified 
for parameter 'bio_integrity_add_page'
include/linux/bio.h:516: error: storage class specified 
for parameter 'bio_integrity_enabled'
include/linux/bio.h:517: error: storage class specified 
for parameter 'bio_integrity_set_tag'
include/linux/bio.h:518: error: storage class specified 
for parameter 'bio_integrity_get_tag'
include/linux/bio.h:519: error: storage class specified 
for parameter 'bio_integrity_prep'
include/linux/bio.h:520: error: storage class specified 
for parameter 'bio_integrity_endio'
include/linux/bio.h:521: error: storage class specified 
for parameter 'bio_integrity_advance'
include/linux/bio.h:522: error: storage class specified 
for parameter 'bio_integrity_trim'
include/linux/bio.h:523: error: storage class specified 
for parameter 'bio_integrity_split'
include/linux/bio.h:524: error: storage class specified 
for parameter 'bio_integrity_clone'
include/linux/bio.h:525: error: storage class specified 
for parameter 'bioset_integrity_create'
include/linux/bio.h:526: error: storage class specified 
for parameter 'bioset_integrity_free'
include/linux/bio.h:527: error: storage class specified 
for parameter 'bio_integrity_init'
In file included from fs/logfs/super.c:14:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/super.c:14:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/super.c:14:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/super.c:14:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/super.c:14:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/blkdev.h:8,
                  from fs/logfs/super.c:15:
include/linux/genhd.h:25: error: storage class specified 
for parameter 'part_type'
include/linux/genhd.h:26: error: storage class specified 
for parameter 'block_depr'
include/linux/genhd.h:27: error: storage class specified 
for parameter 'block_class'
include/linux/genhd.h:29: warning: empty declaration
include/linux/genhd.h:69: warning: empty declaration
include/linux/genhd.h:82: warning: empty declaration
include/linux/genhd.h:94: warning: empty declaration
include/linux/genhd.h:99: warning: empty declaration
include/linux/genhd.h:133: warning: empty declaration
include/linux/genhd.h:139: warning: empty declaration
include/linux/genhd.h:146: warning: empty declaration
include/linux/genhd.h:184: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:195: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:213: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:219: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:226: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:231: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:236: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:240: error: storage class specified 
for parameter 'disk_get_part'
include/linux/genhd.h:243: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:256: warning: empty declaration
include/linux/genhd.h:264: error: storage class specified 
for parameter 'disk_part_iter_init'
include/linux/genhd.h:265: error: storage class specified 
for parameter 'disk_part_iter_next'
include/linux/genhd.h:266: error: storage class specified 
for parameter 'disk_part_iter_exit'
include/linux/genhd.h:269: error: storage class specified 
for parameter 'disk_map_sector_rcu'
include/linux/genhd.h:300: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:309: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:317: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:361: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:368: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:375: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:380: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:388: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:393: error: storage class specified 
for parameter 'part_round_stats'
include/linux/genhd.h:396: error: storage class specified 
for parameter 'add_disk'
include/linux/genhd.h:397: error: storage class specified 
for parameter 'del_gendisk'
include/linux/genhd.h:398: error: storage class specified 
for parameter 'unlink_gendisk'
include/linux/genhd.h:399: error: storage class specified 
for parameter 'get_gendisk'
include/linux/genhd.h:400: error: storage class specified 
for parameter 'bdget_disk'
include/linux/genhd.h:402: error: storage class specified 
for parameter 'set_device_ro'
include/linux/genhd.h:403: error: storage class specified 
for parameter 'set_disk_ro'
include/linux/genhd.h:406: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:411: error: storage class specified 
for parameter 'add_disk_randomness'
include/linux/genhd.h:412: error: storage class specified 
for parameter 'rand_initialize_disk'
include/linux/genhd.h:415: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:419: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:423: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:432: warning: empty declaration
include/linux/genhd.h:439: warning: empty declaration
include/linux/genhd.h:467: warning: empty declaration
include/linux/genhd.h:523: warning: empty declaration
include/linux/genhd.h:530: warning: empty declaration
include/linux/genhd.h:574: error: storage class specified 
for parameter 'blk_alloc_devt'
include/linux/genhd.h:575: error: storage class specified 
for parameter 'blk_free_devt'
include/linux/genhd.h:576: error: storage class specified 
for parameter 'blk_lookup_devt'
include/linux/genhd.h:577: error: storage class specified 
for parameter 'disk_name'
include/linux/genhd.h:579: error: storage class specified 
for parameter 'disk_expand_part_tbl'
include/linux/genhd.h:580: error: storage class specified 
for parameter 'rescan_partitions'
include/linux/genhd.h:585: error: storage class specified 
for parameter 'add_partition'
include/linux/genhd.h:586: error: storage class specified 
for parameter 'delete_partition'
include/linux/genhd.h:587: error: storage class specified 
for parameter 'printk_all_partitions'
include/linux/genhd.h:589: error: storage class specified 
for parameter 'alloc_disk_node'
include/linux/genhd.h:590: error: storage class specified 
for parameter 'alloc_disk'
include/linux/genhd.h:591: error: storage class specified 
for parameter 'get_disk'
include/linux/genhd.h:592: error: storage class specified 
for parameter 'put_disk'
include/linux/genhd.h:597: error: storage class specified 
for parameter 'blk_register_region'
include/linux/genhd.h:598: error: storage class specified 
for parameter 'blk_unregister_region'
include/linux/genhd.h:601: error: storage class specified 
for parameter 'part_size_show'
include/linux/genhd.h:603: error: storage class specified 
for parameter 'part_stat_show'
include/linux/genhd.h:605: error: storage class specified 
for parameter 'part_inflight_show'
In file included from include/linux/backing-dev.h:18,
                  from include/linux/blkdev.h:13,
                  from fs/logfs/super.c:15:
include/linux/writeback.h:10: warning: empty declaration
include/linux/writeback.h:12: error: storage class 
specified for parameter 'inode_lock'
include/linux/writeback.h:17: warning: empty declaration
include/linux/writeback.h:27: warning: empty declaration
include/linux/writeback.h:58: warning: empty declaration
include/linux/writeback.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:77: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:98: error: storage class 
specified for parameter 'dirty_background_ratio'
include/linux/writeback.h:99: error: storage class 
specified for parameter 'dirty_background_bytes'
include/linux/writeback.h:100: error: storage class 
specified for parameter 'vm_dirty_ratio'
include/linux/writeback.h:101: error: storage class 
specified for parameter 'vm_dirty_bytes'
include/linux/writeback.h:102: error: storage class 
specified for parameter 'dirty_writeback_interval'
include/linux/writeback.h:103: error: storage class 
specified for parameter 'dirty_expire_interval'
include/linux/writeback.h:104: error: storage class 
specified for parameter 'vm_highmem_is_dirtyable'
include/linux/writeback.h:105: error: storage class 
specified for parameter 'block_dump'
include/linux/writeback.h:106: error: storage class 
specified for parameter 'laptop_mode'
include/linux/writeback.h:108: error: storage class 
specified for parameter 'determine_dirtyable_memory'
include/linux/writeback.h:112: error: storage class 
specified for parameter 'dirty_background_ratio_handler'
include/linux/writeback.h:115: error: storage class 
specified for parameter 'dirty_background_bytes_handler'
include/linux/writeback.h:118: error: storage class 
specified for parameter 'dirty_ratio_handler'
include/linux/writeback.h:121: error: storage class 
specified for parameter 'dirty_bytes_handler'
include/linux/writeback.h:123: warning: empty declaration
include/linux/writeback.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:142: error: storage class 
specified for parameter 'writepage_t'
include/linux/writeback.h:149: error: expected declaration 
specifiers or '...' before 'writepage_t'
include/linux/writeback.h:154: error: redefinition of 
parameter 'tag_pages_for_writeback'
include/linux/writeback.h:146: error: previous definition 
of 'tag_pages_for_writeback' was here
include/linux/writeback.h:158: error: storage class 
specified for parameter 'nr_pdflush_threads'
In file included from include/linux/blkdev.h:13,
                  from fs/logfs/super.c:15:
include/linux/backing-dev.h:21: warning: empty declaration
include/linux/backing-dev.h:22: warning: empty declaration
include/linux/backing-dev.h:23: warning: empty declaration
include/linux/backing-dev.h:28: warning: empty declaration
include/linux/backing-dev.h:38: error: storage class 
specified for parameter 'congested_fn'
include/linux/backing-dev.h:40: warning: empty declaration
include/linux/backing-dev.h:48: warning: empty declaration
include/linux/backing-dev.h:67: error: expected 
specifier-qualifier-list before 'congested_fn'
include/linux/backing-dev.h:62: warning: empty declaration
include/linux/backing-dev.h:112: error: storage class 
specified for parameter 'bdi_lock'
include/linux/backing-dev.h:113: error: storage class 
specified for parameter 'bdi_list'
include/linux/backing-dev.h:114: error: storage class 
specified for parameter 'bdi_pending_list'
include/linux/backing-dev.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:131: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:147: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:153: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:163: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:169: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:175: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:186: error: storage class 
specified for parameter 'bdi_writeout_inc'
include/linux/backing-dev.h:192: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:252: error: storage class 
specified for parameter 'default_backing_dev_info'
include/linux/backing-dev.h:253: error: storage class 
specified for parameter 'noop_backing_dev_info'
include/linux/backing-dev.h:259: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:266: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:271: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:276: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:281: warning: empty 
declaration
include/linux/backing-dev.h:292: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:297: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:302: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:309: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:314: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:319: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:324: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:329: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:334: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:341: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:347: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/blkdev.h:20,
                  from fs/logfs/super.c:15:
include/linux/bsg.h:20: warning: empty declaration
include/linux/bsg.h:67: warning: empty declaration
include/linux/bsg.h:78: error: storage class specified for 
parameter 'bsg_register_queue'
include/linux/bsg.h:79: error: storage class specified for 
parameter 'bsg_unregister_queue'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/scatterlist.h:4,
                  from include/linux/blkdev.h:23,
                  from fs/logfs/super.c:15:
include/asm-generic/scatterlist.h:6: warning: empty 
declaration
In file included from fs/logfs/super.c:15:
include/linux/blkdev.h:25: warning: empty declaration
include/linux/blkdev.h:27: warning: empty declaration
include/linux/blkdev.h:28: warning: empty declaration
include/linux/blkdev.h:29: warning: empty declaration
include/linux/blkdev.h:30: warning: empty declaration
include/linux/blkdev.h:31: warning: empty declaration
include/linux/blkdev.h:32: warning: empty declaration
include/linux/blkdev.h:37: warning: empty declaration
include/linux/blkdev.h:38: error: storage class specified 
for parameter 'rq_end_io_fn'
include/linux/blkdev.h:40: warning: empty declaration
include/linux/blkdev.h:55: warning: empty declaration
include/linux/blkdev.h:161: error: expected 
specifier-qualifier-list before 'rq_end_io_fn'
include/linux/blkdev.h:79: warning: empty declaration
include/linux/blkdev.h:169: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:177: warning: empty declaration
In file included from include/linux/blkdev.h:186,
                  from fs/logfs/super.c:15:
include/linux/elevator.h:9: error: storage class specified 
for parameter 'elevator_merge_fn'
include/linux/elevator.h:11: error: storage class 
specified for parameter 'elevator_merge_req_fn'
include/linux/elevator.h:13: error: storage class 
specified for parameter 'elevator_merged_fn'
include/linux/elevator.h:15: error: storage class 
specified for parameter 'elevator_allow_merge_fn'
include/linux/elevator.h:18: error: storage class 
specified for parameter 'elevator_bio_merged_fn'
include/linux/elevator.h:20: error: storage class 
specified for parameter 'elevator_dispatch_fn'
include/linux/elevator.h:22: error: storage class 
specified for parameter 'elevator_add_req_fn'
include/linux/elevator.h:23: error: storage class 
specified for parameter 'elevator_queue_empty_fn'
include/linux/elevator.h:24: error: storage class 
specified for parameter 'elevator_request_list_fn'
include/linux/elevator.h:25: error: storage class 
specified for parameter 'elevator_completed_req_fn'
include/linux/elevator.h:26: error: storage class 
specified for parameter 'elevator_may_queue_fn'
include/linux/elevator.h:28: error: storage class 
specified for parameter 'elevator_set_req_fn'
include/linux/elevator.h:29: error: storage class 
specified for parameter 'elevator_put_req_fn'
include/linux/elevator.h:30: error: storage class 
specified for parameter 'elevator_activate_req_fn'
include/linux/elevator.h:31: error: storage class 
specified for parameter 'elevator_deactivate_req_fn'
include/linux/elevator.h:33: error: storage class 
specified for parameter 'elevator_init_fn'
include/linux/elevator.h:34: error: storage class 
specified for parameter 'elevator_exit_fn'
include/linux/elevator.h:38: error: expected 
specifier-qualifier-list before 'elevator_merge_fn'
include/linux/elevator.h:36: warning: empty declaration
include/linux/elevator.h:67: warning: empty declaration
include/linux/elevator.h:76: warning: empty declaration
include/linux/elevator.h:88: warning: empty declaration
include/linux/elevator.h:102: error: storage class 
specified for parameter 'elv_dispatch_sort'
include/linux/elevator.h:103: error: storage class 
specified for parameter 'elv_dispatch_add_tail'
include/linux/elevator.h:104: error: storage class 
specified for parameter 'elv_add_request'
include/linux/elevator.h:105: error: storage class 
specified for parameter '__elv_add_request'
include/linux/elevator.h:106: error: storage class 
specified for parameter 'elv_insert'
include/linux/elevator.h:107: error: storage class 
specified for parameter 'elv_merge'
include/linux/elevator.h:109: error: storage class 
specified for parameter 'elv_merge_requests'
include/linux/elevator.h:110: error: storage class 
specified for parameter 'elv_merged_request'
include/linux/elevator.h:112: error: storage class 
specified for parameter 'elv_bio_merged'
include/linux/elevator.h:113: error: storage class 
specified for parameter 'elv_requeue_request'
include/linux/elevator.h:114: error: storage class 
specified for parameter 'elv_queue_empty'
include/linux/elevator.h:115: error: storage class 
specified for parameter 'elv_former_request'
include/linux/elevator.h:116: error: storage class 
specified for parameter 'elv_latter_request'
include/linux/elevator.h:117: error: storage class 
specified for parameter 'elv_register_queue'
include/linux/elevator.h:118: error: storage class 
specified for parameter 'elv_unregister_queue'
include/linux/elevator.h:119: error: storage class 
specified for parameter 'elv_may_queue'
include/linux/elevator.h:120: error: storage class 
specified for parameter 'elv_abort_queue'
include/linux/elevator.h:121: error: storage class 
specified for parameter 'elv_completed_request'
include/linux/elevator.h:122: error: storage class 
specified for parameter 'elv_set_request'
include/linux/elevator.h:123: error: storage class 
specified for parameter 'elv_put_request'
include/linux/elevator.h:124: error: storage class 
specified for parameter 'elv_drain_elevator'
include/linux/elevator.h:129: error: storage class 
specified for parameter 'elv_register'
include/linux/elevator.h:130: error: storage class 
specified for parameter 'elv_unregister'
include/linux/elevator.h:135: error: storage class 
specified for parameter 'elv_iosched_show'
include/linux/elevator.h:136: error: storage class 
specified for parameter 'elv_iosched_store'
include/linux/elevator.h:138: error: storage class 
specified for parameter 'elevator_init'
include/linux/elevator.h:139: error: storage class 
specified for parameter 'elevator_exit'
include/linux/elevator.h:140: error: storage class 
specified for parameter 'elevator_change'
include/linux/elevator.h:141: error: storage class 
specified for parameter 'elv_rq_merge_ok'
include/linux/elevator.h:146: error: storage class 
specified for parameter 'elv_rb_former_request'
include/linux/elevator.h:147: error: storage class 
specified for parameter 'elv_rb_latter_request'
include/linux/elevator.h:152: error: storage class 
specified for parameter 'elv_rb_add'
include/linux/elevator.h:153: error: storage class 
specified for parameter 'elv_rb_del'
include/linux/elevator.h:154: error: storage class 
specified for parameter 'elv_rb_find'
include/linux/elevator.h:174: warning: empty declaration
In file included from fs/logfs/super.c:15:
include/linux/blkdev.h:188: error: storage class specified 
for parameter 'request_fn_proc'
include/linux/blkdev.h:189: error: storage class specified 
for parameter 'make_request_fn'
include/linux/blkdev.h:190: error: storage class specified 
for parameter 'prep_rq_fn'
include/linux/blkdev.h:191: error: storage class specified 
for parameter 'unprep_rq_fn'
include/linux/blkdev.h:192: error: storage class specified 
for parameter 'unplug_fn'
include/linux/blkdev.h:194: warning: empty declaration
include/linux/blkdev.h:195: warning: empty declaration
include/linux/blkdev.h:202: error: storage class specified 
for parameter 'merge_bvec_fn'
include/linux/blkdev.h:203: error: storage class specified 
for parameter 'softirq_done_fn'
include/linux/blkdev.h:204: error: storage class specified 
for parameter 'dma_drain_needed_fn'
include/linux/blkdev.h:205: error: storage class specified 
for parameter 'lld_busy_fn'
include/linux/blkdev.h:207: warning: empty declaration
include/linux/blkdev.h:213: error: storage class specified 
for parameter 'rq_timed_out_fn'
include/linux/blkdev.h:215: warning: empty declaration
include/linux/blkdev.h:220: warning: empty declaration
include/linux/blkdev.h:232: warning: empty declaration
include/linux/blkdev.h:271: error: expected 
specifier-qualifier-list before 'request_fn_proc'
include/linux/blkdev.h:257: warning: empty declaration
include/linux/blkdev.h:412: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:423: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:429: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:442: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:454: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:461: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:466: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:471: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:517: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:522: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:527: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:534: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:542: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:569: error: storage class specified 
for parameter 'blk_max_low_pfn'
include/linux/blkdev.h:569: error: storage class specified 
for parameter 'blk_max_pfn'
include/linux/blkdev.h:594: error: storage class specified 
for parameter 'init_emergency_isa_pool'
include/linux/blkdev.h:595: error: storage class specified 
for parameter 'blk_queue_bounce'
include/linux/blkdev.h:606: warning: empty declaration
include/linux/blkdev.h:615: warning: empty declaration
include/linux/blkdev.h:641: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:645: error: storage class specified 
for parameter 'blk_register_queue'
include/linux/blkdev.h:646: error: storage class specified 
for parameter 'blk_unregister_queue'
include/linux/blkdev.h:647: error: storage class specified 
for parameter 'register_disk'
include/linux/blkdev.h:648: error: storage class specified 
for parameter 'generic_make_request'
include/linux/blkdev.h:649: error: storage class specified 
for parameter 'blk_rq_init'
include/linux/blkdev.h:650: error: storage class specified 
for parameter 'blk_put_request'
include/linux/blkdev.h:651: error: storage class specified 
for parameter '__blk_put_request'
include/linux/blkdev.h:652: error: storage class specified 
for parameter 'blk_get_request'
include/linux/blkdev.h:654: error: storage class specified 
for parameter 'blk_make_request'
include/linux/blkdev.h:655: error: storage class specified 
for parameter 'blk_insert_request'
include/linux/blkdev.h:656: error: storage class specified 
for parameter 'blk_requeue_request'
include/linux/blkdev.h:658: error: storage class specified 
for parameter 'blk_add_request_payload'
include/linux/blkdev.h:659: error: storage class specified 
for parameter 'blk_rq_check_limits'
include/linux/blkdev.h:660: error: storage class specified 
for parameter 'blk_lld_busy'
include/linux/blkdev.h:664: error: storage class specified 
for parameter 'blk_rq_prep_clone'
include/linux/blkdev.h:665: error: storage class specified 
for parameter 'blk_rq_unprep_clone'
include/linux/blkdev.h:667: error: storage class specified 
for parameter 'blk_insert_cloned_request'
include/linux/blkdev.h:668: error: storage class specified 
for parameter 'blk_plug_device'
include/linux/blkdev.h:669: error: storage class specified 
for parameter 'blk_plug_device_unlocked'
include/linux/blkdev.h:670: error: storage class specified 
for parameter 'blk_remove_plug'
include/linux/blkdev.h:671: error: storage class specified 
for parameter 'blk_recount_segments'
include/linux/blkdev.h:673: error: storage class specified 
for parameter 'scsi_cmd_ioctl'
include/linux/blkdev.h:675: error: storage class specified 
for parameter 'sg_scsi_ioctl'
include/linux/blkdev.h:683: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:692: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:696: error: storage class specified 
for parameter 'blk_start_queue'
include/linux/blkdev.h:697: error: storage class specified 
for parameter 'blk_stop_queue'
include/linux/blkdev.h:698: error: storage class specified 
for parameter 'blk_sync_queue'
include/linux/blkdev.h:699: error: storage class specified 
for parameter '__blk_stop_queue'
include/linux/blkdev.h:700: error: storage class specified 
for parameter '__blk_run_queue'
include/linux/blkdev.h:701: error: storage class specified 
for parameter 'blk_run_queue'
include/linux/blkdev.h:704: error: storage class specified 
for parameter 'blk_rq_map_user'
include/linux/blkdev.h:705: error: storage class specified 
for parameter 'blk_rq_unmap_user'
include/linux/blkdev.h:706: error: storage class specified 
for parameter 'blk_rq_map_kern'
include/linux/blkdev.h:709: error: storage class specified 
for parameter 'blk_rq_map_user_iov'
include/linux/blkdev.h:711: error: storage class specified 
for parameter 'blk_execute_rq'
include/linux/blkdev.h:713: error: expected declaration 
specifiers or '...' before 'rq_end_io_fn'
include/linux/blkdev.h:713: error: storage class specified 
for parameter 'blk_execute_rq_nowait'
include/linux/blkdev.h:714: error: storage class specified 
for parameter 'blk_unplug'
include/linux/blkdev.h:717: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:730: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:735: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:740: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:744: error: storage class specified 
for parameter 'blk_rq_err_bytes'
include/linux/blkdev.h:747: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:752: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:759: error: storage class specified 
for parameter 'blk_peek_request'
include/linux/blkdev.h:760: error: storage class specified 
for parameter 'blk_start_request'
include/linux/blkdev.h:761: error: storage class specified 
for parameter 'blk_fetch_request'
include/linux/blkdev.h:777: error: storage class specified 
for parameter 'blk_update_request'
include/linux/blkdev.h:779: error: storage class specified 
for parameter 'blk_end_request'
include/linux/blkdev.h:780: error: storage class specified 
for parameter 'blk_end_request_all'
include/linux/blkdev.h:781: error: storage class specified 
for parameter 'blk_end_request_cur'
include/linux/blkdev.h:782: error: storage class specified 
for parameter 'blk_end_request_err'
include/linux/blkdev.h:784: error: storage class specified 
for parameter '__blk_end_request'
include/linux/blkdev.h:785: error: storage class specified 
for parameter '__blk_end_request_all'
include/linux/blkdev.h:786: error: storage class specified 
for parameter '__blk_end_request_cur'
include/linux/blkdev.h:787: error: storage class specified 
for parameter '__blk_end_request_err'
include/linux/blkdev.h:789: error: storage class specified 
for parameter 'blk_complete_request'
include/linux/blkdev.h:790: error: storage class specified 
for parameter '__blk_complete_request'
include/linux/blkdev.h:791: error: storage class specified 
for parameter 'blk_abort_request'
include/linux/blkdev.h:792: error: storage class specified 
for parameter 'blk_abort_queue'
include/linux/blkdev.h:793: error: storage class specified 
for parameter 'blk_unprep_request'
include/linux/blkdev.h:798: error: expected ')' before '*' 
token
include/linux/blkdev.h:801: error: expected declaration 
specifiers or '...' before 'request_fn_proc'
include/linux/blkdev.h:802: error: storage class specified 
for parameter 'blk_init_allocated_queue_node'
include/linux/blkdev.h:803: error: expected ')' before '*' 
token
include/linux/blkdev.h:805: error: expected declaration 
specifiers or '...' before 'request_fn_proc'
include/linux/blkdev.h:805: error: storage class specified 
for parameter 'blk_init_allocated_queue'
include/linux/blkdev.h:806: error: storage class specified 
for parameter 'blk_cleanup_queue'
include/linux/blkdev.h:807: error: expected declaration 
specifiers or '...' before 'make_request_fn'
include/linux/blkdev.h:807: error: storage class specified 
for parameter 'blk_queue_make_request'
include/linux/blkdev.h:808: error: storage class specified 
for parameter 'blk_queue_bounce_limit'
include/linux/blkdev.h:809: error: storage class specified 
for parameter 'blk_queue_max_hw_sectors'
include/linux/blkdev.h:810: error: storage class specified 
for parameter 'blk_queue_max_segments'
include/linux/blkdev.h:811: error: storage class specified 
for parameter 'blk_queue_max_segment_size'
include/linux/blkdev.h:813: error: storage class specified 
for parameter 'blk_queue_max_discard_sectors'
include/linux/blkdev.h:814: error: storage class specified 
for parameter 'blk_queue_logical_block_size'
include/linux/blkdev.h:815: error: storage class specified 
for parameter 'blk_queue_physical_block_size'
include/linux/blkdev.h:817: error: storage class specified 
for parameter 'blk_queue_alignment_offset'
include/linux/blkdev.h:818: error: storage class specified 
for parameter 'blk_limits_io_min'
include/linux/blkdev.h:819: error: storage class specified 
for parameter 'blk_queue_io_min'
include/linux/blkdev.h:820: error: storage class specified 
for parameter 'blk_limits_io_opt'
include/linux/blkdev.h:821: error: storage class specified 
for parameter 'blk_queue_io_opt'
include/linux/blkdev.h:822: error: storage class specified 
for parameter 'blk_set_default_limits'
include/linux/blkdev.h:824: error: storage class specified 
for parameter 'blk_stack_limits'
include/linux/blkdev.h:826: error: storage class specified 
for parameter 'bdev_stack_limits'
include/linux/blkdev.h:828: error: storage class specified 
for parameter 'disk_stack_limits'
include/linux/blkdev.h:829: error: storage class specified 
for parameter 'blk_queue_stack_limits'
include/linux/blkdev.h:830: error: storage class specified 
for parameter 'blk_queue_dma_pad'
include/linux/blkdev.h:831: error: storage class specified 
for parameter 'blk_queue_update_dma_pad'
include/linux/blkdev.h:833: error: expected declaration 
specifiers or '...' before 'dma_drain_needed_fn'
include/linux/blkdev.h:834: error: storage class specified 
for parameter 'blk_queue_dma_drain'
include/linux/blkdev.h:835: error: expected declaration 
specifiers or '...' before 'lld_busy_fn'
include/linux/blkdev.h:835: error: storage class specified 
for parameter 'blk_queue_lld_busy'
include/linux/blkdev.h:836: error: storage class specified 
for parameter 'blk_queue_segment_boundary'
include/linux/blkdev.h:837: error: expected declaration 
specifiers or '...' before 'prep_rq_fn'
include/linux/blkdev.h:837: error: storage class specified 
for parameter 'blk_queue_prep_rq'
include/linux/blkdev.h:838: error: expected declaration 
specifiers or '...' before 'unprep_rq_fn'
include/linux/blkdev.h:838: error: storage class specified 
for parameter 'blk_queue_unprep_rq'
include/linux/blkdev.h:839: error: expected declaration 
specifiers or '...' before 'merge_bvec_fn'
include/linux/blkdev.h:839: error: storage class specified 
for parameter 'blk_queue_merge_bvec'
include/linux/blkdev.h:840: error: storage class specified 
for parameter 'blk_queue_dma_alignment'
include/linux/blkdev.h:841: error: storage class specified 
for parameter 'blk_queue_update_dma_alignment'
include/linux/blkdev.h:842: error: expected declaration 
specifiers or '...' before 'softirq_done_fn'
include/linux/blkdev.h:842: error: storage class specified 
for parameter 'blk_queue_softirq_done'
include/linux/blkdev.h:843: error: expected declaration 
specifiers or '...' before 'rq_timed_out_fn'
include/linux/blkdev.h:843: error: storage class specified 
for parameter 'blk_queue_rq_timed_out'
include/linux/blkdev.h:844: error: storage class specified 
for parameter 'blk_queue_rq_timeout'
include/linux/blkdev.h:845: error: storage class specified 
for parameter 'blk_queue_flush'
include/linux/blkdev.h:846: error: storage class specified 
for parameter 'blk_get_backing_dev_info'
include/linux/blkdev.h:848: error: storage class specified 
for parameter 'blk_rq_map_sg'
include/linux/blkdev.h:849: error: storage class specified 
for parameter 'blk_dump_rq_flags'
include/linux/blkdev.h:850: error: storage class specified 
for parameter 'generic_unplug_device'
include/linux/blkdev.h:851: error: storage class specified 
for parameter 'nr_blockdev_pages'
include/linux/blkdev.h:856: error: storage class specified 
for parameter 'blk_put_queue'
include/linux/blkdev.h:862: error: storage class specified 
for parameter 'blk_queue_start_tag'
include/linux/blkdev.h:863: error: storage class specified 
for parameter 'blk_queue_find_tag'
include/linux/blkdev.h:864: error: storage class specified 
for parameter 'blk_queue_end_tag'
include/linux/blkdev.h:865: error: storage class specified 
for parameter 'blk_queue_init_tags'
include/linux/blkdev.h:866: error: storage class specified 
for parameter 'blk_queue_free_tags'
include/linux/blkdev.h:867: error: storage class specified 
for parameter 'blk_queue_resize_tags'
include/linux/blkdev.h:868: error: storage class specified 
for parameter 'blk_queue_invalidate_tags'
include/linux/blkdev.h:869: error: storage class specified 
for parameter 'blk_init_tags'
include/linux/blkdev.h:870: error: storage class specified 
for parameter 'blk_free_tags'
include/linux/blkdev.h:874: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:882: error: storage class specified 
for parameter 'blkdev_issue_flush'
include/linux/blkdev.h:884: error: storage class specified 
for parameter 'blkdev_issue_discard'
include/linux/blkdev.h:886: error: storage class specified 
for parameter 'blkdev_issue_zeroout'
include/linux/blkdev.h:889: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:896: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:903: error: storage class specified 
for parameter 'blk_verify_command'
include/linux/blkdev.h:905: warning: empty declaration
include/linux/blkdev.h:916: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:921: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:926: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:931: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:936: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:941: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:946: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:956: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:961: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:966: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:971: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:976: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:981: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:986: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:991: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:999: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1008: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1021: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1029: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1037: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1045: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1050: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1056: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1063: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1073: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1077: error: storage class 
specified for parameter 'Sector'
include/linux/blkdev.h:1079: error: expected declaration 
specifiers or '...' before 'Sector'
include/linux/blkdev.h:1081: error: expected ')' before 
'p'
include/linux/blkdev.h:1086: warning: empty declaration
include/linux/blkdev.h:1120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1127: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1140: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1144: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1145: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1146: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1147: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1160: warning: empty declaration
include/linux/blkdev.h:1169: error: storage class 
specified for parameter 'integrity_gen_fn'
include/linux/blkdev.h:1170: error: storage class 
specified for parameter 'integrity_vrfy_fn'
include/linux/blkdev.h:1171: error: storage class 
specified for parameter 'integrity_set_tag_fn'
include/linux/blkdev.h:1172: error: storage class 
specified for parameter 'integrity_get_tag_fn'
include/linux/blkdev.h:1175: error: expected 
specifier-qualifier-list before 'integrity_gen_fn'
include/linux/blkdev.h:1174: warning: empty declaration
include/linux/blkdev.h:1190: error: storage class 
specified for parameter 'blk_integrity_register'
include/linux/blkdev.h:1191: error: storage class 
specified for parameter 'blk_integrity_unregister'
include/linux/blkdev.h:1192: error: storage class 
specified for parameter 'blk_integrity_compare'
include/linux/blkdev.h:1194: error: storage class 
specified for parameter 'blk_rq_map_integrity_sg'
include/linux/blkdev.h:1195: error: storage class 
specified for parameter 'blk_rq_count_integrity_sg'
include/linux/blkdev.h:1197: error: storage class 
specified for parameter 'blk_integrity_merge_rq'
include/linux/blkdev.h:1199: error: storage class 
specified for parameter 'blk_integrity_merge_bio'
include/linux/blkdev.h:1203: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1208: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1213: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1222: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1228: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1249: warning: empty declaration
include/linux/blkdev.h:1266: error: storage class 
specified for parameter '__blkdev_driver_ioctl'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/statfs.h:11,
                  from include/linux/statfs.h:5,
                  from fs/logfs/super.c:17:
include/asm-generic/statfs.h:7: error: storage class 
specified for parameter 'fsid_t'
include/asm-generic/statfs.h:25: warning: empty 
declaration
include/asm-generic/statfs.h:48: warning: empty 
declaration
include/asm-generic/statfs.h:71: warning: empty 
declaration
In file included from fs/logfs/super.c:17:
include/linux/statfs.h:7: warning: empty declaration
In file included from fs/logfs/super.c:18:
include/linux/buffer_head.h:19: warning: empty declaration
include/linux/buffer_head.h:45: warning: empty declaration
include/linux/buffer_head.h:46: warning: empty declaration
include/linux/buffer_head.h:47: warning: empty declaration
include/linux/buffer_head.h:48: error: storage class 
specified for parameter 'bh_end_io_t'
include/linux/buffer_head.h:69: error: expected 
specifier-qualifier-list before 'bh_end_io_t'
include/linux/buffer_head.h:59: warning: empty declaration
include/linux/buffer_head.h:113: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:113: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:113: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:114: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:114: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:114: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:115: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:115: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:116: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:116: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:116: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:118: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:118: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:119: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:119: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:119: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:122: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:122: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:122: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:124: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:124: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:124: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:126: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:126: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:126: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:144: error: expected 
declaration specifiers or '...' before 'bh_end_io_t'
include/linux/buffer_head.h:190: error: storage class 
specified for parameter 'buffer_heads_over_limit'
include/linux/buffer_head.h:200: error: expected 
declaration specifiers or '...' before 'bh_end_io_t'
include/linux/buffer_head.h:242: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:254: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:260: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:266: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:273: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:279: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:285: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:291: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:297: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:305: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:312: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:317: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:323: error: storage class 
specified for parameter '__set_page_dirty_buffers'
fs/logfs/super.c:20: error: storage class specified for 
parameter 'emergency_mutex'
fs/logfs/super.c:20: error: parameter 'emergency_mutex' is 
initialized
fs/logfs/super.c:21: error: storage class specified for 
parameter 'emergency_page'
fs/logfs/super.c:24: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:46: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:54: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:89: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:106: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:119: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:135: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:153: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:166: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:178: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:210: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:235: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:252: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:263: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:299: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:329: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:369: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:383: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:414: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:456: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:507: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:540: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:595: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:625: error: storage class specified for 
parameter 'logfs_fs_type'
fs/logfs/super.c:625: error: parameter 'logfs_fs_type' is 
initialized
fs/logfs/super.c:628: error: 'logfs_mount' undeclared 
(first use in this function)
fs/logfs/super.c:628: error: (Each undeclared identifier 
is reported only once
fs/logfs/super.c:628: error: for each function it appears 
in.)
fs/logfs/super.c:629: error: 'logfs_kill_sb' undeclared 
(first use in this function)
fs/logfs/super.c:635: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:659: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:666: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:666: error: 'init_module' defined both 
normally and as an alias
fs/logfs/super.c:666: error: expected declaration 
specifiers before ';' token
fs/logfs/super.c:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/super.c:667: error: 'cleanup_module' defined both 
normally and as an alias
fs/logfs/super.c:667: error: expected declaration 
specifiers before ';' token
fs/logfs/super.c:669: error: storage class specified for 
parameter '__mod_license669'
fs/logfs/super.c:669: error: parameter '__mod_license669' 
is initialized
fs/logfs/super.c:669: warning: '__used__' attribute 
ignored
fs/logfs/super.c:669: error: section attribute not allowed 
for '__mod_license669'
fs/logfs/super.c:669: error: alignment may not be 
specified for '__mod_license669'
fs/logfs/super.c:670: error: storage class specified for 
parameter '__mod_author670'
fs/logfs/super.c:670: error: parameter '__mod_author670' 
is initialized
fs/logfs/super.c:670: warning: '__used__' attribute 
ignored
fs/logfs/super.c:670: error: section attribute not allowed 
for '__mod_author670'
fs/logfs/super.c:670: error: alignment may not be 
specified for '__mod_author670'
fs/logfs/super.c:671: error: storage class specified for 
parameter '__mod_description671'
fs/logfs/super.c:671: error: parameter 
'__mod_description671' is initialized
fs/logfs/super.c:671: warning: '__used__' attribute 
ignored
fs/logfs/super.c:671: error: section attribute not allowed 
for '__mod_description671'
fs/logfs/super.c:671: error: alignment may not be 
specified for '__mod_description671'
fs/logfs/super.c:671: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/super.c:671: error: expected '{' at end of input
fs/logfs/super.c:671: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/super.o] Error 1 (ignored)
   CC [M]  fs/logfs/dev_bdev.o
In file included from fs/logfs/dev_bdev.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from include/linux/ioprio.h:5,
                  from include/linux/bio.h:25,
                  from fs/logfs/dev_bdev.c:9:
include/linux/iocontext.h:7: warning: empty declaration
include/linux/iocontext.h:8: warning: empty declaration
include/linux/iocontext.h:34: warning: empty declaration
include/linux/iocontext.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/iocontext.h:73: warning: empty declaration
In file included from include/linux/bio.h:25,
                  from fs/logfs/dev_bdev.c:9:
include/linux/ioprio.h:26: warning: empty declaration
include/linux/ioprio.h:38: warning: empty declaration
include/linux/ioprio.h:50: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:58: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:66: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:75: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/ioprio.h:87: error: storage class specified 
for parameter 'ioprio_best'
include/linux/ioprio.h:89: error: storage class specified 
for parameter 'set_task_ioprio'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:44,
                  from include/linux/bio.h:29,
                  from fs/logfs/dev_bdev.c:9:
include/xen/xen.h:4: warning: empty declaration
In file included from include/linux/bio.h:29,
                  from fs/logfs/dev_bdev.c:9:
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:56: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:57: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:58: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:60: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:61: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:62: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:64: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:65: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:66: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:68: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:69: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:70: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:93: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:104: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:134: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:152: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:167: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:196: 
error: storage class specified for parameter 
'ioremap_nocache'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:197: 
error: storage class specified for parameter 
'ioremap_cache'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:199: 
error: storage class specified for parameter 
'ioremap_prot'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:205: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:209: 
error: storage class specified for parameter 'iounmap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:211: 
error: storage class specified for parameter 
'set_iounmap_nonlazy'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:215,
                  from include/linux/bio.h:29,
                  from fs/logfs/dev_bdev.c:9:
include/asm-generic/iomap.h:28: error: storage class 
specified for parameter 'ioread8'
include/asm-generic/iomap.h:29: error: storage class 
specified for parameter 'ioread16'
include/asm-generic/iomap.h:30: error: storage class 
specified for parameter 'ioread16be'
include/asm-generic/iomap.h:31: error: storage class 
specified for parameter 'ioread32'
include/asm-generic/iomap.h:32: error: storage class 
specified for parameter 'ioread32be'
include/asm-generic/iomap.h:34: error: storage class 
specified for parameter 'iowrite8'
include/asm-generic/iomap.h:35: error: storage class 
specified for parameter 'iowrite16'
include/asm-generic/iomap.h:36: error: storage class 
specified for parameter 'iowrite16be'
include/asm-generic/iomap.h:37: error: storage class 
specified for parameter 'iowrite32'
include/asm-generic/iomap.h:38: error: storage class 
specified for parameter 'iowrite32be'
include/asm-generic/iomap.h:51: error: storage class 
specified for parameter 'ioread8_rep'
include/asm-generic/iomap.h:52: error: storage class 
specified for parameter 'ioread16_rep'
include/asm-generic/iomap.h:53: error: storage class 
specified for parameter 'ioread32_rep'
include/asm-generic/iomap.h:55: error: storage class 
specified for parameter 'iowrite8_rep'
include/asm-generic/iomap.h:56: error: storage class 
specified for parameter 'iowrite16_rep'
include/asm-generic/iomap.h:57: error: storage class 
specified for parameter 'iowrite32_rep'
include/asm-generic/iomap.h:60: error: storage class 
specified for parameter 'ioport_map'
include/asm-generic/iomap.h:61: error: storage class 
specified for parameter 'ioport_unmap'
include/asm-generic/iomap.h:68: warning: empty declaration
include/asm-generic/iomap.h:69: error: storage class 
specified for parameter 'pci_iomap'
include/asm-generic/iomap.h:70: error: storage class 
specified for parameter 'pci_iounmap'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:217,
                  from include/linux/bio.h:29,
                  from fs/logfs/dev_bdev.c:9:
include/linux/vmalloc.h:8: warning: empty declaration
include/linux/vmalloc.h:10: error: storage class specified 
for parameter 'vmap_lazy_unmap'
include/linux/vmalloc.h:28: warning: empty declaration
include/linux/vmalloc.h:42: error: storage class specified 
for parameter 'vm_unmap_ram'
include/linux/vmalloc.h:44: error: storage class specified 
for parameter 'vm_map_ram'
include/linux/vmalloc.h:45: error: storage class specified 
for parameter 'vm_unmap_aliases'
include/linux/vmalloc.h:48: error: storage class specified 
for parameter 'vmalloc_init'
include/linux/vmalloc.h:48: error: section attribute not 
allowed for 'vmalloc_init'
include/linux/vmalloc.h:48: warning: '__cold__' attribute 
ignored
include/linux/vmalloc.h:48: error: 
'no_instrument_function' attribute applies only to 
functions
include/linux/vmalloc.h:55: error: storage class specified 
for parameter 'vmalloc'
include/linux/vmalloc.h:56: error: storage class specified 
for parameter 'vzalloc'
include/linux/vmalloc.h:57: error: storage class specified 
for parameter 'vmalloc_user'
include/linux/vmalloc.h:58: error: storage class specified 
for parameter 'vmalloc_node'
include/linux/vmalloc.h:59: error: storage class specified 
for parameter 'vzalloc_node'
include/linux/vmalloc.h:60: error: storage class specified 
for parameter 'vmalloc_exec'
include/linux/vmalloc.h:61: error: storage class specified 
for parameter 'vmalloc_32'
include/linux/vmalloc.h:62: error: storage class specified 
for parameter 'vmalloc_32_user'
include/linux/vmalloc.h:63: error: storage class specified 
for parameter '__vmalloc'
include/linux/vmalloc.h:65: error: storage class specified 
for parameter '__vmalloc_area'
include/linux/vmalloc.h:66: error: storage class specified 
for parameter 'vfree'
include/linux/vmalloc.h:69: error: storage class specified 
for parameter 'vmap'
include/linux/vmalloc.h:70: error: storage class specified 
for parameter 'vunmap'
include/linux/vmalloc.h:73: error: storage class specified 
for parameter 'remap_vmalloc_range'
include/linux/vmalloc.h:81: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/vmalloc.h:86: error: storage class specified 
for parameter 'get_vm_area'
include/linux/vmalloc.h:88: error: storage class specified 
for parameter 'get_vm_area_caller'
include/linux/vmalloc.h:90: error: storage class specified 
for parameter '__get_vm_area'
include/linux/vmalloc.h:94: error: storage class specified 
for parameter '__get_vm_area_caller'
include/linux/vmalloc.h:97: error: storage class specified 
for parameter 'get_vm_area_node'
include/linux/vmalloc.h:98: error: storage class specified 
for parameter 'remove_vm_area'
include/linux/vmalloc.h:101: error: storage class 
specified for parameter 'map_vm_area'
include/linux/vmalloc.h:103: error: storage class 
specified for parameter 'map_kernel_range_noflush'
include/linux/vmalloc.h:104: error: storage class 
specified for parameter 'unmap_kernel_range_noflush'
include/linux/vmalloc.h:105: error: storage class 
specified for parameter 'unmap_kernel_range'
include/linux/vmalloc.h:108: error: storage class 
specified for parameter 'alloc_vm_area'
include/linux/vmalloc.h:109: error: storage class 
specified for parameter 'free_vm_area'
include/linux/vmalloc.h:112: error: storage class 
specified for parameter 'vread'
include/linux/vmalloc.h:113: error: storage class 
specified for parameter 'vwrite'
include/linux/vmalloc.h:118: error: storage class 
specified for parameter 'vmlist_lock'
include/linux/vmalloc.h:119: error: storage class 
specified for parameter 'vmlist'
include/linux/vmalloc.h:120: error: storage class 
specified for parameter 'vm_area_register_early'
include/linux/vmalloc.h:120: error: section attribute not 
allowed for 'vm_area_register_early'
include/linux/vmalloc.h:120: warning: '__cold__' attribute 
ignored
include/linux/vmalloc.h:120: error: 
'no_instrument_function' attribute applies only to 
functions
In file included from include/linux/bio.h:29,
                  from fs/logfs/dev_bdev.c:9:
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:226: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:232: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:238: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:261: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:269: 
error: storage class specified for parameter 
'native_io_delay'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:271: 
error: storage class specified for parameter 
'io_delay_type'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:272: 
error: storage class specified for parameter 
'io_delay_init'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:330: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:331: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:332: 
error: expected '=', ',', ';', 'asm' or '__attribute__' 
before '{' token
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:334: 
error: storage class specified for parameter 
'xlate_dev_mem_ptr'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:335: 
error: storage class specified for parameter 
'unxlate_dev_mem_ptr'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:338: 
error: storage class specified for parameter 
'ioremap_change_attr'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:339: 
error: storage class specified for parameter 'ioremap_wc'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:346: 
error: storage class specified for parameter 
'early_ioremap_init'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:347: 
error: storage class specified for parameter 
'early_ioremap_reset'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:349: 
error: storage class specified for parameter 
'early_ioremap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:351: 
error: storage class specified for parameter 
'early_memremap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:352: 
error: storage class specified for parameter 
'early_iounmap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:353: 
error: storage class specified for parameter 
'fixup_early_ioremap'
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/io.h:354: 
error: storage class specified for parameter 
'is_early_ioremap_ptep'
In file included from fs/logfs/dev_bdev.c:9:
include/linux/bio.h:75: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:83: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:91: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:173: warning: empty declaration
include/linux/bio.h:202: warning: empty declaration
include/linux/bio.h:212: error: storage class specified 
for parameter 'bio_split'
include/linux/bio.h:213: error: storage class specified 
for parameter 'bio_pair_release'
include/linux/bio.h:215: error: storage class specified 
for parameter 'bioset_create'
include/linux/bio.h:216: error: storage class specified 
for parameter 'bioset_free'
include/linux/bio.h:218: error: storage class specified 
for parameter 'bio_alloc'
include/linux/bio.h:219: error: storage class specified 
for parameter 'bio_kmalloc'
include/linux/bio.h:220: error: storage class specified 
for parameter 'bio_alloc_bioset'
include/linux/bio.h:221: error: storage class specified 
for parameter 'bio_put'
include/linux/bio.h:222: error: storage class specified 
for parameter 'bio_free'
include/linux/bio.h:224: error: storage class specified 
for parameter 'bio_endio'
include/linux/bio.h:225: warning: empty declaration
include/linux/bio.h:226: error: storage class specified 
for parameter 'bio_phys_segments'
include/linux/bio.h:228: error: storage class specified 
for parameter '__bio_clone'
include/linux/bio.h:229: error: storage class specified 
for parameter 'bio_clone'
include/linux/bio.h:231: error: storage class specified 
for parameter 'bio_init'
include/linux/bio.h:233: error: storage class specified 
for parameter 'bio_add_page'
include/linux/bio.h:235: error: storage class specified 
for parameter 'bio_add_pc_page'
include/linux/bio.h:236: error: storage class specified 
for parameter 'bio_get_nr_vecs'
include/linux/bio.h:237: error: storage class specified 
for parameter 'bio_sector_offset'
include/linux/bio.h:239: error: storage class specified 
for parameter 'bio_map_user'
include/linux/bio.h:240: warning: empty declaration
include/linux/bio.h:241: warning: empty declaration
include/linux/bio.h:244: error: storage class specified 
for parameter 'bio_map_user_iov'
include/linux/bio.h:245: error: storage class specified 
for parameter 'bio_unmap_user'
include/linux/bio.h:247: error: storage class specified 
for parameter 'bio_map_kern'
include/linux/bio.h:249: error: storage class specified 
for parameter 'bio_copy_kern'
include/linux/bio.h:250: error: storage class specified 
for parameter 'bio_set_pages_dirty'
include/linux/bio.h:251: error: storage class specified 
for parameter 'bio_check_pages_dirty'
include/linux/bio.h:260: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:265: error: storage class specified 
for parameter 'bio_copy_user'
include/linux/bio.h:268: error: storage class specified 
for parameter 'bio_copy_user_iov'
include/linux/bio.h:269: error: storage class specified 
for parameter 'bio_uncopy_user'
include/linux/bio.h:271: error: storage class specified 
for parameter 'bvec_alloc_bs'
include/linux/bio.h:272: error: storage class specified 
for parameter 'bvec_free_bs'
include/linux/bio.h:273: error: storage class specified 
for parameter 'bvec_nr_vecs'
include/linux/bio.h:279: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:293: warning: empty declaration
include/linux/bio.h:304: warning: empty declaration
include/linux/bio.h:310: error: storage class specified 
for parameter 'fs_bio_set'
include/linux/bio.h:311: error: storage class specified 
for parameter 'bvec_slabs'
include/linux/bio.h:311: error: section attribute not 
allowed for 'bvec_slabs'
include/linux/bio.h:325: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:341: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:362: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:375: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:386: warning: empty declaration
include/linux/bio.h:392: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:397: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:405: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:416: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:428: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:438: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:452: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:465: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:470: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:485: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/bio.h:512: error: storage class specified 
for parameter 'bio_integrity_alloc_bioset'
include/linux/bio.h:513: error: storage class specified 
for parameter 'bio_integrity_alloc'
include/linux/bio.h:514: error: storage class specified 
for parameter 'bio_integrity_free'
include/linux/bio.h:515: error: storage class specified 
for parameter 'bio_integrity_add_page'
include/linux/bio.h:516: error: storage class specified 
for parameter 'bio_integrity_enabled'
include/linux/bio.h:517: error: storage class specified 
for parameter 'bio_integrity_set_tag'
include/linux/bio.h:518: error: storage class specified 
for parameter 'bio_integrity_get_tag'
include/linux/bio.h:519: error: storage class specified 
for parameter 'bio_integrity_prep'
include/linux/bio.h:520: error: storage class specified 
for parameter 'bio_integrity_endio'
include/linux/bio.h:521: error: storage class specified 
for parameter 'bio_integrity_advance'
include/linux/bio.h:522: error: storage class specified 
for parameter 'bio_integrity_trim'
include/linux/bio.h:523: error: storage class specified 
for parameter 'bio_integrity_split'
include/linux/bio.h:524: error: storage class specified 
for parameter 'bio_integrity_clone'
include/linux/bio.h:525: error: storage class specified 
for parameter 'bioset_integrity_create'
include/linux/bio.h:526: error: storage class specified 
for parameter 'bioset_integrity_free'
include/linux/bio.h:527: error: storage class specified 
for parameter 'bio_integrity_init'
In file included from include/linux/genhd.h:15,
                  from include/linux/blkdev.h:8,
                  from fs/logfs/dev_bdev.c:10:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from include/linux/genhd.h:15,
                  from include/linux/blkdev.h:8,
                  from fs/logfs/dev_bdev.c:10:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from include/linux/genhd.h:15,
                  from include/linux/blkdev.h:8,
                  from fs/logfs/dev_bdev.c:10:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from include/linux/genhd.h:15,
                  from include/linux/blkdev.h:8,
                  from fs/logfs/dev_bdev.c:10:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/genhd.h:15,
                  from include/linux/blkdev.h:8,
                  from fs/logfs/dev_bdev.c:10:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/blkdev.h:8,
                  from fs/logfs/dev_bdev.c:10:
include/linux/genhd.h:25: error: storage class specified 
for parameter 'part_type'
include/linux/genhd.h:26: error: storage class specified 
for parameter 'block_depr'
include/linux/genhd.h:27: error: storage class specified 
for parameter 'block_class'
include/linux/genhd.h:29: warning: empty declaration
include/linux/genhd.h:69: warning: empty declaration
include/linux/genhd.h:82: warning: empty declaration
include/linux/genhd.h:94: warning: empty declaration
include/linux/genhd.h:99: warning: empty declaration
include/linux/genhd.h:133: warning: empty declaration
include/linux/genhd.h:139: warning: empty declaration
include/linux/genhd.h:146: warning: empty declaration
include/linux/genhd.h:184: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:195: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:213: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:219: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:226: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:231: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:236: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:240: error: storage class specified 
for parameter 'disk_get_part'
include/linux/genhd.h:243: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:256: warning: empty declaration
include/linux/genhd.h:264: error: storage class specified 
for parameter 'disk_part_iter_init'
include/linux/genhd.h:265: error: storage class specified 
for parameter 'disk_part_iter_next'
include/linux/genhd.h:266: error: storage class specified 
for parameter 'disk_part_iter_exit'
include/linux/genhd.h:269: error: storage class specified 
for parameter 'disk_map_sector_rcu'
include/linux/genhd.h:300: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:309: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:317: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:361: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:368: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:375: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:380: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:388: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:393: error: storage class specified 
for parameter 'part_round_stats'
include/linux/genhd.h:396: error: storage class specified 
for parameter 'add_disk'
include/linux/genhd.h:397: error: storage class specified 
for parameter 'del_gendisk'
include/linux/genhd.h:398: error: storage class specified 
for parameter 'unlink_gendisk'
include/linux/genhd.h:399: error: storage class specified 
for parameter 'get_gendisk'
include/linux/genhd.h:400: error: storage class specified 
for parameter 'bdget_disk'
include/linux/genhd.h:402: error: storage class specified 
for parameter 'set_device_ro'
include/linux/genhd.h:403: error: storage class specified 
for parameter 'set_disk_ro'
include/linux/genhd.h:406: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:411: error: storage class specified 
for parameter 'add_disk_randomness'
include/linux/genhd.h:412: error: storage class specified 
for parameter 'rand_initialize_disk'
include/linux/genhd.h:415: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:419: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:423: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/genhd.h:432: warning: empty declaration
include/linux/genhd.h:439: warning: empty declaration
include/linux/genhd.h:467: warning: empty declaration
include/linux/genhd.h:523: warning: empty declaration
include/linux/genhd.h:530: warning: empty declaration
include/linux/genhd.h:574: error: storage class specified 
for parameter 'blk_alloc_devt'
include/linux/genhd.h:575: error: storage class specified 
for parameter 'blk_free_devt'
include/linux/genhd.h:576: error: storage class specified 
for parameter 'blk_lookup_devt'
include/linux/genhd.h:577: error: storage class specified 
for parameter 'disk_name'
include/linux/genhd.h:579: error: storage class specified 
for parameter 'disk_expand_part_tbl'
include/linux/genhd.h:580: error: storage class specified 
for parameter 'rescan_partitions'
include/linux/genhd.h:585: error: storage class specified 
for parameter 'add_partition'
include/linux/genhd.h:586: error: storage class specified 
for parameter 'delete_partition'
include/linux/genhd.h:587: error: storage class specified 
for parameter 'printk_all_partitions'
include/linux/genhd.h:589: error: storage class specified 
for parameter 'alloc_disk_node'
include/linux/genhd.h:590: error: storage class specified 
for parameter 'alloc_disk'
include/linux/genhd.h:591: error: storage class specified 
for parameter 'get_disk'
include/linux/genhd.h:592: error: storage class specified 
for parameter 'put_disk'
include/linux/genhd.h:597: error: storage class specified 
for parameter 'blk_register_region'
include/linux/genhd.h:598: error: storage class specified 
for parameter 'blk_unregister_region'
include/linux/genhd.h:601: error: storage class specified 
for parameter 'part_size_show'
include/linux/genhd.h:603: error: storage class specified 
for parameter 'part_stat_show'
include/linux/genhd.h:605: error: storage class specified 
for parameter 'part_inflight_show'
In file included from include/linux/backing-dev.h:18,
                  from include/linux/blkdev.h:13,
                  from fs/logfs/dev_bdev.c:10:
include/linux/writeback.h:10: warning: empty declaration
include/linux/writeback.h:12: error: storage class 
specified for parameter 'inode_lock'
include/linux/writeback.h:17: warning: empty declaration
include/linux/writeback.h:27: warning: empty declaration
include/linux/writeback.h:58: warning: empty declaration
include/linux/writeback.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:77: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:98: error: storage class 
specified for parameter 'dirty_background_ratio'
include/linux/writeback.h:99: error: storage class 
specified for parameter 'dirty_background_bytes'
include/linux/writeback.h:100: error: storage class 
specified for parameter 'vm_dirty_ratio'
include/linux/writeback.h:101: error: storage class 
specified for parameter 'vm_dirty_bytes'
include/linux/writeback.h:102: error: storage class 
specified for parameter 'dirty_writeback_interval'
include/linux/writeback.h:103: error: storage class 
specified for parameter 'dirty_expire_interval'
include/linux/writeback.h:104: error: storage class 
specified for parameter 'vm_highmem_is_dirtyable'
include/linux/writeback.h:105: error: storage class 
specified for parameter 'block_dump'
include/linux/writeback.h:106: error: storage class 
specified for parameter 'laptop_mode'
include/linux/writeback.h:108: error: storage class 
specified for parameter 'determine_dirtyable_memory'
include/linux/writeback.h:112: error: storage class 
specified for parameter 'dirty_background_ratio_handler'
include/linux/writeback.h:115: error: storage class 
specified for parameter 'dirty_background_bytes_handler'
include/linux/writeback.h:118: error: storage class 
specified for parameter 'dirty_ratio_handler'
include/linux/writeback.h:121: error: storage class 
specified for parameter 'dirty_bytes_handler'
include/linux/writeback.h:123: warning: empty declaration
include/linux/writeback.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/writeback.h:142: error: storage class 
specified for parameter 'writepage_t'
include/linux/writeback.h:149: error: expected declaration 
specifiers or '...' before 'writepage_t'
include/linux/writeback.h:154: error: redefinition of 
parameter 'tag_pages_for_writeback'
include/linux/writeback.h:146: error: previous definition 
of 'tag_pages_for_writeback' was here
include/linux/writeback.h:158: error: storage class 
specified for parameter 'nr_pdflush_threads'
In file included from include/linux/blkdev.h:13,
                  from fs/logfs/dev_bdev.c:10:
include/linux/backing-dev.h:21: warning: empty declaration
include/linux/backing-dev.h:22: warning: empty declaration
include/linux/backing-dev.h:23: warning: empty declaration
include/linux/backing-dev.h:28: warning: empty declaration
include/linux/backing-dev.h:38: error: storage class 
specified for parameter 'congested_fn'
include/linux/backing-dev.h:40: warning: empty declaration
include/linux/backing-dev.h:48: warning: empty declaration
include/linux/backing-dev.h:67: error: expected 
specifier-qualifier-list before 'congested_fn'
include/linux/backing-dev.h:62: warning: empty declaration
include/linux/backing-dev.h:112: error: storage class 
specified for parameter 'bdi_lock'
include/linux/backing-dev.h:113: error: storage class 
specified for parameter 'bdi_list'
include/linux/backing-dev.h:114: error: storage class 
specified for parameter 'bdi_pending_list'
include/linux/backing-dev.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:131: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:137: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:147: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:153: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:163: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:169: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:175: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:186: error: storage class 
specified for parameter 'bdi_writeout_inc'
include/linux/backing-dev.h:192: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:252: error: storage class 
specified for parameter 'default_backing_dev_info'
include/linux/backing-dev.h:253: error: storage class 
specified for parameter 'noop_backing_dev_info'
include/linux/backing-dev.h:259: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:266: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:271: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:276: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:281: warning: empty 
declaration
include/linux/backing-dev.h:292: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:297: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:302: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:309: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:314: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:319: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:324: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:329: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:334: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:341: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/backing-dev.h:347: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/blkdev.h:20,
                  from fs/logfs/dev_bdev.c:10:
include/linux/bsg.h:20: warning: empty declaration
include/linux/bsg.h:67: warning: empty declaration
include/linux/bsg.h:78: error: storage class specified for 
parameter 'bsg_register_queue'
include/linux/bsg.h:79: error: storage class specified for 
parameter 'bsg_unregister_queue'
In file included from 
/usr/src/linux-2.6.37-rc1-i486-1sys/arch/x86/include/asm/scatterlist.h:4,
                  from include/linux/blkdev.h:23,
                  from fs/logfs/dev_bdev.c:10:
include/asm-generic/scatterlist.h:6: warning: empty 
declaration
In file included from fs/logfs/dev_bdev.c:10:
include/linux/blkdev.h:25: warning: empty declaration
include/linux/blkdev.h:27: warning: empty declaration
include/linux/blkdev.h:28: warning: empty declaration
include/linux/blkdev.h:29: warning: empty declaration
include/linux/blkdev.h:30: warning: empty declaration
include/linux/blkdev.h:31: warning: empty declaration
include/linux/blkdev.h:32: warning: empty declaration
include/linux/blkdev.h:37: warning: empty declaration
include/linux/blkdev.h:38: error: storage class specified 
for parameter 'rq_end_io_fn'
include/linux/blkdev.h:40: warning: empty declaration
include/linux/blkdev.h:55: warning: empty declaration
include/linux/blkdev.h:161: error: expected 
specifier-qualifier-list before 'rq_end_io_fn'
include/linux/blkdev.h:79: warning: empty declaration
include/linux/blkdev.h:169: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:177: warning: empty declaration
In file included from include/linux/blkdev.h:186,
                  from fs/logfs/dev_bdev.c:10:
include/linux/elevator.h:9: error: storage class specified 
for parameter 'elevator_merge_fn'
include/linux/elevator.h:11: error: storage class 
specified for parameter 'elevator_merge_req_fn'
include/linux/elevator.h:13: error: storage class 
specified for parameter 'elevator_merged_fn'
include/linux/elevator.h:15: error: storage class 
specified for parameter 'elevator_allow_merge_fn'
include/linux/elevator.h:18: error: storage class 
specified for parameter 'elevator_bio_merged_fn'
include/linux/elevator.h:20: error: storage class 
specified for parameter 'elevator_dispatch_fn'
include/linux/elevator.h:22: error: storage class 
specified for parameter 'elevator_add_req_fn'
include/linux/elevator.h:23: error: storage class 
specified for parameter 'elevator_queue_empty_fn'
include/linux/elevator.h:24: error: storage class 
specified for parameter 'elevator_request_list_fn'
include/linux/elevator.h:25: error: storage class 
specified for parameter 'elevator_completed_req_fn'
include/linux/elevator.h:26: error: storage class 
specified for parameter 'elevator_may_queue_fn'
include/linux/elevator.h:28: error: storage class 
specified for parameter 'elevator_set_req_fn'
include/linux/elevator.h:29: error: storage class 
specified for parameter 'elevator_put_req_fn'
include/linux/elevator.h:30: error: storage class 
specified for parameter 'elevator_activate_req_fn'
include/linux/elevator.h:31: error: storage class 
specified for parameter 'elevator_deactivate_req_fn'
include/linux/elevator.h:33: error: storage class 
specified for parameter 'elevator_init_fn'
include/linux/elevator.h:34: error: storage class 
specified for parameter 'elevator_exit_fn'
include/linux/elevator.h:38: error: expected 
specifier-qualifier-list before 'elevator_merge_fn'
include/linux/elevator.h:36: warning: empty declaration
include/linux/elevator.h:67: warning: empty declaration
include/linux/elevator.h:76: warning: empty declaration
include/linux/elevator.h:88: warning: empty declaration
include/linux/elevator.h:102: error: storage class 
specified for parameter 'elv_dispatch_sort'
include/linux/elevator.h:103: error: storage class 
specified for parameter 'elv_dispatch_add_tail'
include/linux/elevator.h:104: error: storage class 
specified for parameter 'elv_add_request'
include/linux/elevator.h:105: error: storage class 
specified for parameter '__elv_add_request'
include/linux/elevator.h:106: error: storage class 
specified for parameter 'elv_insert'
include/linux/elevator.h:107: error: storage class 
specified for parameter 'elv_merge'
include/linux/elevator.h:109: error: storage class 
specified for parameter 'elv_merge_requests'
include/linux/elevator.h:110: error: storage class 
specified for parameter 'elv_merged_request'
include/linux/elevator.h:112: error: storage class 
specified for parameter 'elv_bio_merged'
include/linux/elevator.h:113: error: storage class 
specified for parameter 'elv_requeue_request'
include/linux/elevator.h:114: error: storage class 
specified for parameter 'elv_queue_empty'
include/linux/elevator.h:115: error: storage class 
specified for parameter 'elv_former_request'
include/linux/elevator.h:116: error: storage class 
specified for parameter 'elv_latter_request'
include/linux/elevator.h:117: error: storage class 
specified for parameter 'elv_register_queue'
include/linux/elevator.h:118: error: storage class 
specified for parameter 'elv_unregister_queue'
include/linux/elevator.h:119: error: storage class 
specified for parameter 'elv_may_queue'
include/linux/elevator.h:120: error: storage class 
specified for parameter 'elv_abort_queue'
include/linux/elevator.h:121: error: storage class 
specified for parameter 'elv_completed_request'
include/linux/elevator.h:122: error: storage class 
specified for parameter 'elv_set_request'
include/linux/elevator.h:123: error: storage class 
specified for parameter 'elv_put_request'
include/linux/elevator.h:124: error: storage class 
specified for parameter 'elv_drain_elevator'
include/linux/elevator.h:129: error: storage class 
specified for parameter 'elv_register'
include/linux/elevator.h:130: error: storage class 
specified for parameter 'elv_unregister'
include/linux/elevator.h:135: error: storage class 
specified for parameter 'elv_iosched_show'
include/linux/elevator.h:136: error: storage class 
specified for parameter 'elv_iosched_store'
include/linux/elevator.h:138: error: storage class 
specified for parameter 'elevator_init'
include/linux/elevator.h:139: error: storage class 
specified for parameter 'elevator_exit'
include/linux/elevator.h:140: error: storage class 
specified for parameter 'elevator_change'
include/linux/elevator.h:141: error: storage class 
specified for parameter 'elv_rq_merge_ok'
include/linux/elevator.h:146: error: storage class 
specified for parameter 'elv_rb_former_request'
include/linux/elevator.h:147: error: storage class 
specified for parameter 'elv_rb_latter_request'
include/linux/elevator.h:152: error: storage class 
specified for parameter 'elv_rb_add'
include/linux/elevator.h:153: error: storage class 
specified for parameter 'elv_rb_del'
include/linux/elevator.h:154: error: storage class 
specified for parameter 'elv_rb_find'
include/linux/elevator.h:174: warning: empty declaration
In file included from fs/logfs/dev_bdev.c:10:
include/linux/blkdev.h:188: error: storage class specified 
for parameter 'request_fn_proc'
include/linux/blkdev.h:189: error: storage class specified 
for parameter 'make_request_fn'
include/linux/blkdev.h:190: error: storage class specified 
for parameter 'prep_rq_fn'
include/linux/blkdev.h:191: error: storage class specified 
for parameter 'unprep_rq_fn'
include/linux/blkdev.h:192: error: storage class specified 
for parameter 'unplug_fn'
include/linux/blkdev.h:194: warning: empty declaration
include/linux/blkdev.h:195: warning: empty declaration
include/linux/blkdev.h:202: error: storage class specified 
for parameter 'merge_bvec_fn'
include/linux/blkdev.h:203: error: storage class specified 
for parameter 'softirq_done_fn'
include/linux/blkdev.h:204: error: storage class specified 
for parameter 'dma_drain_needed_fn'
include/linux/blkdev.h:205: error: storage class specified 
for parameter 'lld_busy_fn'
include/linux/blkdev.h:207: warning: empty declaration
include/linux/blkdev.h:213: error: storage class specified 
for parameter 'rq_timed_out_fn'
include/linux/blkdev.h:215: warning: empty declaration
include/linux/blkdev.h:220: warning: empty declaration
include/linux/blkdev.h:232: warning: empty declaration
include/linux/blkdev.h:271: error: expected 
specifier-qualifier-list before 'request_fn_proc'
include/linux/blkdev.h:257: warning: empty declaration
include/linux/blkdev.h:412: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:423: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:429: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:442: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:454: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:461: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:466: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:471: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:517: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:522: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:527: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:534: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:542: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:569: error: storage class specified 
for parameter 'blk_max_low_pfn'
include/linux/blkdev.h:569: error: storage class specified 
for parameter 'blk_max_pfn'
include/linux/blkdev.h:594: error: storage class specified 
for parameter 'init_emergency_isa_pool'
include/linux/blkdev.h:595: error: storage class specified 
for parameter 'blk_queue_bounce'
include/linux/blkdev.h:606: warning: empty declaration
include/linux/blkdev.h:615: warning: empty declaration
include/linux/blkdev.h:641: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:645: error: storage class specified 
for parameter 'blk_register_queue'
include/linux/blkdev.h:646: error: storage class specified 
for parameter 'blk_unregister_queue'
include/linux/blkdev.h:647: error: storage class specified 
for parameter 'register_disk'
include/linux/blkdev.h:648: error: storage class specified 
for parameter 'generic_make_request'
include/linux/blkdev.h:649: error: storage class specified 
for parameter 'blk_rq_init'
include/linux/blkdev.h:650: error: storage class specified 
for parameter 'blk_put_request'
include/linux/blkdev.h:651: error: storage class specified 
for parameter '__blk_put_request'
include/linux/blkdev.h:652: error: storage class specified 
for parameter 'blk_get_request'
include/linux/blkdev.h:654: error: storage class specified 
for parameter 'blk_make_request'
include/linux/blkdev.h:655: error: storage class specified 
for parameter 'blk_insert_request'
include/linux/blkdev.h:656: error: storage class specified 
for parameter 'blk_requeue_request'
include/linux/blkdev.h:658: error: storage class specified 
for parameter 'blk_add_request_payload'
include/linux/blkdev.h:659: error: storage class specified 
for parameter 'blk_rq_check_limits'
include/linux/blkdev.h:660: error: storage class specified 
for parameter 'blk_lld_busy'
include/linux/blkdev.h:664: error: storage class specified 
for parameter 'blk_rq_prep_clone'
include/linux/blkdev.h:665: error: storage class specified 
for parameter 'blk_rq_unprep_clone'
include/linux/blkdev.h:667: error: storage class specified 
for parameter 'blk_insert_cloned_request'
include/linux/blkdev.h:668: error: storage class specified 
for parameter 'blk_plug_device'
include/linux/blkdev.h:669: error: storage class specified 
for parameter 'blk_plug_device_unlocked'
include/linux/blkdev.h:670: error: storage class specified 
for parameter 'blk_remove_plug'
include/linux/blkdev.h:671: error: storage class specified 
for parameter 'blk_recount_segments'
include/linux/blkdev.h:673: error: storage class specified 
for parameter 'scsi_cmd_ioctl'
include/linux/blkdev.h:675: error: storage class specified 
for parameter 'sg_scsi_ioctl'
include/linux/blkdev.h:683: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:692: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:696: error: storage class specified 
for parameter 'blk_start_queue'
include/linux/blkdev.h:697: error: storage class specified 
for parameter 'blk_stop_queue'
include/linux/blkdev.h:698: error: storage class specified 
for parameter 'blk_sync_queue'
include/linux/blkdev.h:699: error: storage class specified 
for parameter '__blk_stop_queue'
include/linux/blkdev.h:700: error: storage class specified 
for parameter '__blk_run_queue'
include/linux/blkdev.h:701: error: storage class specified 
for parameter 'blk_run_queue'
include/linux/blkdev.h:704: error: storage class specified 
for parameter 'blk_rq_map_user'
include/linux/blkdev.h:705: error: storage class specified 
for parameter 'blk_rq_unmap_user'
include/linux/blkdev.h:706: error: storage class specified 
for parameter 'blk_rq_map_kern'
include/linux/blkdev.h:709: error: storage class specified 
for parameter 'blk_rq_map_user_iov'
include/linux/blkdev.h:711: error: storage class specified 
for parameter 'blk_execute_rq'
include/linux/blkdev.h:713: error: expected declaration 
specifiers or '...' before 'rq_end_io_fn'
include/linux/blkdev.h:713: error: storage class specified 
for parameter 'blk_execute_rq_nowait'
include/linux/blkdev.h:714: error: storage class specified 
for parameter 'blk_unplug'
include/linux/blkdev.h:717: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:730: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:735: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:740: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:744: error: storage class specified 
for parameter 'blk_rq_err_bytes'
include/linux/blkdev.h:747: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:752: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:759: error: storage class specified 
for parameter 'blk_peek_request'
include/linux/blkdev.h:760: error: storage class specified 
for parameter 'blk_start_request'
include/linux/blkdev.h:761: error: storage class specified 
for parameter 'blk_fetch_request'
include/linux/blkdev.h:777: error: storage class specified 
for parameter 'blk_update_request'
include/linux/blkdev.h:779: error: storage class specified 
for parameter 'blk_end_request'
include/linux/blkdev.h:780: error: storage class specified 
for parameter 'blk_end_request_all'
include/linux/blkdev.h:781: error: storage class specified 
for parameter 'blk_end_request_cur'
include/linux/blkdev.h:782: error: storage class specified 
for parameter 'blk_end_request_err'
include/linux/blkdev.h:784: error: storage class specified 
for parameter '__blk_end_request'
include/linux/blkdev.h:785: error: storage class specified 
for parameter '__blk_end_request_all'
include/linux/blkdev.h:786: error: storage class specified 
for parameter '__blk_end_request_cur'
include/linux/blkdev.h:787: error: storage class specified 
for parameter '__blk_end_request_err'
include/linux/blkdev.h:789: error: storage class specified 
for parameter 'blk_complete_request'
include/linux/blkdev.h:790: error: storage class specified 
for parameter '__blk_complete_request'
include/linux/blkdev.h:791: error: storage class specified 
for parameter 'blk_abort_request'
include/linux/blkdev.h:792: error: storage class specified 
for parameter 'blk_abort_queue'
include/linux/blkdev.h:793: error: storage class specified 
for parameter 'blk_unprep_request'
include/linux/blkdev.h:798: error: expected ')' before '*' 
token
include/linux/blkdev.h:801: error: expected declaration 
specifiers or '...' before 'request_fn_proc'
include/linux/blkdev.h:802: error: storage class specified 
for parameter 'blk_init_allocated_queue_node'
include/linux/blkdev.h:803: error: expected ')' before '*' 
token
include/linux/blkdev.h:805: error: expected declaration 
specifiers or '...' before 'request_fn_proc'
include/linux/blkdev.h:805: error: storage class specified 
for parameter 'blk_init_allocated_queue'
include/linux/blkdev.h:806: error: storage class specified 
for parameter 'blk_cleanup_queue'
include/linux/blkdev.h:807: error: expected declaration 
specifiers or '...' before 'make_request_fn'
include/linux/blkdev.h:807: error: storage class specified 
for parameter 'blk_queue_make_request'
include/linux/blkdev.h:808: error: storage class specified 
for parameter 'blk_queue_bounce_limit'
include/linux/blkdev.h:809: error: storage class specified 
for parameter 'blk_queue_max_hw_sectors'
include/linux/blkdev.h:810: error: storage class specified 
for parameter 'blk_queue_max_segments'
include/linux/blkdev.h:811: error: storage class specified 
for parameter 'blk_queue_max_segment_size'
include/linux/blkdev.h:813: error: storage class specified 
for parameter 'blk_queue_max_discard_sectors'
include/linux/blkdev.h:814: error: storage class specified 
for parameter 'blk_queue_logical_block_size'
include/linux/blkdev.h:815: error: storage class specified 
for parameter 'blk_queue_physical_block_size'
include/linux/blkdev.h:817: error: storage class specified 
for parameter 'blk_queue_alignment_offset'
include/linux/blkdev.h:818: error: storage class specified 
for parameter 'blk_limits_io_min'
include/linux/blkdev.h:819: error: storage class specified 
for parameter 'blk_queue_io_min'
include/linux/blkdev.h:820: error: storage class specified 
for parameter 'blk_limits_io_opt'
include/linux/blkdev.h:821: error: storage class specified 
for parameter 'blk_queue_io_opt'
include/linux/blkdev.h:822: error: storage class specified 
for parameter 'blk_set_default_limits'
include/linux/blkdev.h:824: error: storage class specified 
for parameter 'blk_stack_limits'
include/linux/blkdev.h:826: error: storage class specified 
for parameter 'bdev_stack_limits'
include/linux/blkdev.h:828: error: storage class specified 
for parameter 'disk_stack_limits'
include/linux/blkdev.h:829: error: storage class specified 
for parameter 'blk_queue_stack_limits'
include/linux/blkdev.h:830: error: storage class specified 
for parameter 'blk_queue_dma_pad'
include/linux/blkdev.h:831: error: storage class specified 
for parameter 'blk_queue_update_dma_pad'
include/linux/blkdev.h:833: error: expected declaration 
specifiers or '...' before 'dma_drain_needed_fn'
include/linux/blkdev.h:834: error: storage class specified 
for parameter 'blk_queue_dma_drain'
include/linux/blkdev.h:835: error: expected declaration 
specifiers or '...' before 'lld_busy_fn'
include/linux/blkdev.h:835: error: storage class specified 
for parameter 'blk_queue_lld_busy'
include/linux/blkdev.h:836: error: storage class specified 
for parameter 'blk_queue_segment_boundary'
include/linux/blkdev.h:837: error: expected declaration 
specifiers or '...' before 'prep_rq_fn'
include/linux/blkdev.h:837: error: storage class specified 
for parameter 'blk_queue_prep_rq'
include/linux/blkdev.h:838: error: expected declaration 
specifiers or '...' before 'unprep_rq_fn'
include/linux/blkdev.h:838: error: storage class specified 
for parameter 'blk_queue_unprep_rq'
include/linux/blkdev.h:839: error: expected declaration 
specifiers or '...' before 'merge_bvec_fn'
include/linux/blkdev.h:839: error: storage class specified 
for parameter 'blk_queue_merge_bvec'
include/linux/blkdev.h:840: error: storage class specified 
for parameter 'blk_queue_dma_alignment'
include/linux/blkdev.h:841: error: storage class specified 
for parameter 'blk_queue_update_dma_alignment'
include/linux/blkdev.h:842: error: expected declaration 
specifiers or '...' before 'softirq_done_fn'
include/linux/blkdev.h:842: error: storage class specified 
for parameter 'blk_queue_softirq_done'
include/linux/blkdev.h:843: error: expected declaration 
specifiers or '...' before 'rq_timed_out_fn'
include/linux/blkdev.h:843: error: storage class specified 
for parameter 'blk_queue_rq_timed_out'
include/linux/blkdev.h:844: error: storage class specified 
for parameter 'blk_queue_rq_timeout'
include/linux/blkdev.h:845: error: storage class specified 
for parameter 'blk_queue_flush'
include/linux/blkdev.h:846: error: storage class specified 
for parameter 'blk_get_backing_dev_info'
include/linux/blkdev.h:848: error: storage class specified 
for parameter 'blk_rq_map_sg'
include/linux/blkdev.h:849: error: storage class specified 
for parameter 'blk_dump_rq_flags'
include/linux/blkdev.h:850: error: storage class specified 
for parameter 'generic_unplug_device'
include/linux/blkdev.h:851: error: storage class specified 
for parameter 'nr_blockdev_pages'
include/linux/blkdev.h:856: error: storage class specified 
for parameter 'blk_put_queue'
include/linux/blkdev.h:862: error: storage class specified 
for parameter 'blk_queue_start_tag'
include/linux/blkdev.h:863: error: storage class specified 
for parameter 'blk_queue_find_tag'
include/linux/blkdev.h:864: error: storage class specified 
for parameter 'blk_queue_end_tag'
include/linux/blkdev.h:865: error: storage class specified 
for parameter 'blk_queue_init_tags'
include/linux/blkdev.h:866: error: storage class specified 
for parameter 'blk_queue_free_tags'
include/linux/blkdev.h:867: error: storage class specified 
for parameter 'blk_queue_resize_tags'
include/linux/blkdev.h:868: error: storage class specified 
for parameter 'blk_queue_invalidate_tags'
include/linux/blkdev.h:869: error: storage class specified 
for parameter 'blk_init_tags'
include/linux/blkdev.h:870: error: storage class specified 
for parameter 'blk_free_tags'
include/linux/blkdev.h:874: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:882: error: storage class specified 
for parameter 'blkdev_issue_flush'
include/linux/blkdev.h:884: error: storage class specified 
for parameter 'blkdev_issue_discard'
include/linux/blkdev.h:886: error: storage class specified 
for parameter 'blkdev_issue_zeroout'
include/linux/blkdev.h:889: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:896: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:903: error: storage class specified 
for parameter 'blk_verify_command'
include/linux/blkdev.h:905: warning: empty declaration
include/linux/blkdev.h:916: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:921: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:926: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:931: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:936: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:941: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:946: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:956: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:961: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:966: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:971: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:976: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:981: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:986: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:991: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:999: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1008: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1021: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1029: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1037: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1045: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1050: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1056: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1063: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1073: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1077: error: storage class 
specified for parameter 'Sector'
include/linux/blkdev.h:1079: error: expected declaration 
specifiers or '...' before 'Sector'
include/linux/blkdev.h:1081: error: expected ')' before 
'p'
include/linux/blkdev.h:1086: warning: empty declaration
include/linux/blkdev.h:1120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1127: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1140: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1144: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1145: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1146: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1147: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1160: warning: empty declaration
include/linux/blkdev.h:1169: error: storage class 
specified for parameter 'integrity_gen_fn'
include/linux/blkdev.h:1170: error: storage class 
specified for parameter 'integrity_vrfy_fn'
include/linux/blkdev.h:1171: error: storage class 
specified for parameter 'integrity_set_tag_fn'
include/linux/blkdev.h:1172: error: storage class 
specified for parameter 'integrity_get_tag_fn'
include/linux/blkdev.h:1175: error: expected 
specifier-qualifier-list before 'integrity_gen_fn'
include/linux/blkdev.h:1174: warning: empty declaration
include/linux/blkdev.h:1190: error: storage class 
specified for parameter 'blk_integrity_register'
include/linux/blkdev.h:1191: error: storage class 
specified for parameter 'blk_integrity_unregister'
include/linux/blkdev.h:1192: error: storage class 
specified for parameter 'blk_integrity_compare'
include/linux/blkdev.h:1194: error: storage class 
specified for parameter 'blk_rq_map_integrity_sg'
include/linux/blkdev.h:1195: error: storage class 
specified for parameter 'blk_rq_count_integrity_sg'
include/linux/blkdev.h:1197: error: storage class 
specified for parameter 'blk_integrity_merge_rq'
include/linux/blkdev.h:1199: error: storage class 
specified for parameter 'blk_integrity_merge_bio'
include/linux/blkdev.h:1203: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1208: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1213: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1222: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1228: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/blkdev.h:1249: warning: empty declaration
include/linux/blkdev.h:1266: error: storage class 
specified for parameter '__blkdev_driver_ioctl'
In file included from fs/logfs/dev_bdev.c:11:
include/linux/buffer_head.h:19: warning: empty declaration
include/linux/buffer_head.h:45: warning: empty declaration
include/linux/buffer_head.h:46: warning: empty declaration
include/linux/buffer_head.h:47: warning: empty declaration
include/linux/buffer_head.h:48: error: storage class 
specified for parameter 'bh_end_io_t'
include/linux/buffer_head.h:69: error: expected 
specifier-qualifier-list before 'bh_end_io_t'
include/linux/buffer_head.h:59: warning: empty declaration
include/linux/buffer_head.h:113: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:113: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:113: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:114: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:114: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:114: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:115: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:115: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:116: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:116: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:116: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:117: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:118: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:118: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:119: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:119: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:119: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:120: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:121: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:122: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:122: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:122: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:123: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:124: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:124: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:124: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:125: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:126: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:126: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:126: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:144: error: expected 
declaration specifiers or '...' before 'bh_end_io_t'
include/linux/buffer_head.h:190: error: storage class 
specified for parameter 'buffer_heads_over_limit'
include/linux/buffer_head.h:200: error: expected 
declaration specifiers or '...' before 'bh_end_io_t'
include/linux/buffer_head.h:242: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:254: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:260: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:266: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:273: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:279: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:285: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:291: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:297: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:305: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:312: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:317: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/buffer_head.h:323: error: storage class 
specified for parameter '__set_page_dirty_buffers'
fs/logfs/dev_bdev.c:17: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:22: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:48: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:65: error: storage class specified for 
parameter 'wq'
fs/logfs/dev_bdev.c:65: error: parameter 'wq' is 
initialized
fs/logfs/dev_bdev.c:68: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:93: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:151: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:176: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:191: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:242: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:265: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:272: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:282: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:294: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:302: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:307: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:311: error: storage class specified 
for parameter 'bd_devops'
fs/logfs/dev_bdev.c:311: error: parameter 'bd_devops' is 
initialized
fs/logfs/dev_bdev.c:312: error: 'bdev_find_first_sb' 
undeclared (first use in this function)
fs/logfs/dev_bdev.c:312: error: (Each undeclared 
identifier is reported only once
fs/logfs/dev_bdev.c:312: error: for each function it 
appears in.)
fs/logfs/dev_bdev.c:313: error: 'bdev_find_last_sb' 
undeclared (first use in this function)
fs/logfs/dev_bdev.c:314: error: 'bdev_write_sb' undeclared 
(first use in this function)
fs/logfs/dev_bdev.c:315: error: 'bdev_readpage' undeclared 
(first use in this function)
fs/logfs/dev_bdev.c:316: error: 'bdev_writeseg' undeclared 
(first use in this function)
fs/logfs/dev_bdev.c:317: error: 'bdev_erase' undeclared 
(first use in this function)
fs/logfs/dev_bdev.c:318: error: 'bdev_can_write_buf' 
undeclared (first use in this function)
fs/logfs/dev_bdev.c:319: error: 'bdev_sync' undeclared 
(first use in this function)
fs/logfs/dev_bdev.c:320: error: 'bdev_put_device' 
undeclared (first use in this function)
fs/logfs/dev_bdev.c:325: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_bdev.c:342: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/dev_bdev.c:342: error: expected '{' at end of 
input
fs/logfs/dev_bdev.c:342: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/dev_bdev.o] Error 1 (ignored)
   CC [M]  fs/logfs/dev_mtd.o
In file included from fs/logfs/dev_mtd.c:8:
fs/logfs/logfs.h: In function 'logfs_get_sb_mtd':
fs/logfs/logfs.h:498: error: storage class specified for 
parameter 'logfs_symlink_iops'
fs/logfs/logfs.h:499: error: storage class specified for 
parameter 'logfs_dir_iops'
fs/logfs/logfs.h:500: error: storage class specified for 
parameter 'logfs_dir_fops'
fs/logfs/logfs.h:504: error: storage class specified for 
parameter 'logfs_reg_iops'
fs/logfs/logfs.h:505: error: storage class specified for 
parameter 'logfs_reg_fops'
fs/logfs/logfs.h:506: error: storage class specified for 
parameter 'logfs_reg_aops'
fs/logfs/logfs.h:519: error: storage class specified for 
parameter 'logfs_super_operations'
fs/logfs/logfs.h:580: error: storage class specified for 
parameter 'indirect_block_ops'
fs/logfs/logfs.h:607: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:613: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:627: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:632: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:637: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:652: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:657: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:662: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:667: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:672: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:677: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:682: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:687: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:692: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:701: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:712: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:718: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:724: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
fs/logfs/logfs.h:729: error: expected '=', ',', ';', 'asm' 
or '__attribute__' before '{' token
In file included from fs/logfs/dev_mtd.c:10:
include/linux/mount.h:18: warning: empty declaration
include/linux/mount.h:19: warning: empty declaration
include/linux/mount.h:20: warning: empty declaration
include/linux/mount.h:21: warning: empty declaration
include/linux/mount.h:49: warning: empty declaration
include/linux/mount.h:90: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/mount.h:99: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/mount.h:105: warning: empty declaration
include/linux/mount.h:107: error: storage class specified 
for parameter 'mnt_want_write'
include/linux/mount.h:108: error: storage class specified 
for parameter 'mnt_want_write_file'
include/linux/mount.h:109: error: storage class specified 
for parameter 'mnt_clone_write'
include/linux/mount.h:110: error: storage class specified 
for parameter 'mnt_drop_write'
include/linux/mount.h:111: error: storage class specified 
for parameter 'mntput_no_expire'
include/linux/mount.h:112: error: storage class specified 
for parameter 'mnt_pin'
include/linux/mount.h:113: error: storage class specified 
for parameter 'mnt_unpin'
include/linux/mount.h:114: error: storage class specified 
for parameter '__mnt_is_readonly'
include/linux/mount.h:117: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/mount.h:125: error: storage class specified 
for parameter 'do_kern_mount'
include/linux/mount.h:127: warning: empty declaration
include/linux/mount.h:130: error: storage class specified 
for parameter 'vfs_kern_mount'
include/linux/mount.h:132: warning: empty declaration
include/linux/mount.h:134: warning: empty declaration
include/linux/mount.h:136: error: storage class specified 
for parameter 'do_add_mount'
include/linux/mount.h:138: error: storage class specified 
for parameter 'mark_mounts_for_expiry'
include/linux/mount.h:140: error: storage class specified 
for parameter 'name_to_dev_t'
In file included from fs/logfs/dev_mtd.c:12:
include/linux/slab.h:98: error: section attribute not 
allowed for 'kmem_cache_init'
include/linux/slab.h:98: warning: '__cold__' attribute 
ignored
include/linux/slab.h:98: error: 'no_instrument_function' 
attribute applies only to functions
In file included from include/linux/slub_def.h:13,
                  from include/linux/slab.h:168,
                  from fs/logfs/dev_mtd.c:12:
include/linux/kmemleak.h:60: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:64: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:69: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:72: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:75: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:78: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:81: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:84: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:87: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:90: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/kmemleak.h:93: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from include/linux/slub_def.h:15,
                  from include/linux/slab.h:168,
                  from fs/logfs/dev_mtd.c:12:
include/trace/events/kmem.h:43: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:45: error: storage class 
specified for parameter '__tracepoint_kmalloc'
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:45: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:51: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:53: error: storage class 
specified for parameter '__tracepoint_kmem_cache_alloc'
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:53: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:59: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:97: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:99: error: storage class 
specified for parameter '__tracepoint_kmalloc_node'
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:99: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:106: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:108: error: storage class 
specified for parameter 
'__tracepoint_kmem_cache_alloc_node'
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:108: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:115: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:134: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:136: error: storage class 
specified for parameter '__tracepoint_kfree'
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:136: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:141: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:143: error: storage class 
specified for parameter '__tracepoint_kmem_cache_free'
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:143: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:148: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:150: error: storage class 
specified for parameter '__tracepoint_mm_page_free_direct'
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:150: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:170: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:172: error: storage class 
specified for parameter '__tracepoint_mm_pagevec_free'
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:172: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:192: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:194: error: storage class 
specified for parameter '__tracepoint_mm_page_alloc'
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:194: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:221: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:247: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:249: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_zone_locked'
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:249: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:254: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:256: error: storage class 
specified for parameter '__tracepoint_mm_page_pcpu_drain'
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:256: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:265: error: expected 
declaration specifiers before ';' token
include/trace/events/kmem.h:267: error: storage class 
specified for parameter 
'__tracepoint_mm_page_alloc_extfrag'
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:267: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/trace/events/kmem.h:303: error: expected 
declaration specifiers before ';' token
In file included from include/linux/slab.h:168,
                  from fs/logfs/dev_mtd.c:12:
include/linux/slub_def.h:17: warning: empty declaration
include/linux/slub_def.h:38: warning: empty declaration
include/linux/slub_def.h:47: warning: empty declaration
include/linux/slub_def.h:63: warning: empty declaration
include/linux/slub_def.h:70: warning: empty declaration
include/linux/slub_def.h:148: error: storage class 
specified for parameter 'kmalloc_caches'
include/linux/slub_def.h:155: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:207: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:220: error: storage class 
specified for parameter 'kmem_cache_alloc_notrace'
include/linux/slub_def.h:230: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
include/linux/slub_def.h:241: error: expected '=', ',', 
';', 'asm' or '__attribute__' before '{' token
In file included from fs/logfs/dev_mtd.c:12:
include/linux/slab.h:227: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:245: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:250: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:254: error: redefinition of parameter 
'kmem_cache_alloc'
include/linux/slub_def.h:216: error: previous definition 
of 'kmem_cache_alloc' was here
include/linux/slab.h:258: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:273: error: storage class specified 
for parameter '__kmalloc_track_caller'
include/linux/slab.h:312: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:322: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:333: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
include/linux/slab.h:337: error: section attribute not 
allowed for 'kmem_cache_init_late'
include/linux/slab.h:337: warning: '__cold__' attribute 
ignored
include/linux/slab.h:337: error: 'no_instrument_function' 
attribute applies only to functions
fs/logfs/dev_mtd.c:17: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:35: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:66: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:71: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:89: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:116: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:124: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:147: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:167: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:189: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:210: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:234: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:239: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:257: error: storage class specified for 
parameter 'mtd_devops'
fs/logfs/dev_mtd.c:257: error: parameter 'mtd_devops' is 
initialized
fs/logfs/dev_mtd.c:258: error: 'mtd_find_first_sb' 
undeclared (first use in this function)
fs/logfs/dev_mtd.c:258: error: (Each undeclared identifier 
is reported only once
fs/logfs/dev_mtd.c:258: error: for each function it 
appears in.)
fs/logfs/dev_mtd.c:259: error: 'mtd_find_last_sb' 
undeclared (first use in this function)
fs/logfs/dev_mtd.c:260: error: 'mtd_readpage' undeclared 
(first use in this function)
fs/logfs/dev_mtd.c:261: error: 'mtd_writeseg' undeclared 
(first use in this function)
fs/logfs/dev_mtd.c:262: error: 'mtd_erase' undeclared 
(first use in this function)
fs/logfs/dev_mtd.c:263: error: 'mtd_can_write_buf' 
undeclared (first use in this function)
fs/logfs/dev_mtd.c:264: error: 'mtd_sync' undeclared 
(first use in this function)
fs/logfs/dev_mtd.c:265: error: 'mtd_put_device' undeclared 
(first use in this function)
fs/logfs/dev_mtd.c:269: error: expected '=', ',', ';', 
'asm' or '__attribute__' before '{' token
fs/logfs/dev_mtd.c:278: error: old-style parameter 
declarations in prototyped function definition
fs/logfs/dev_mtd.c:278: error: expected '{' at end of 
input
fs/logfs/dev_mtd.c:278: warning: no return statement in 
function returning non-void
make[2]: [fs/logfs/dev_mtd.o] Error 1 (ignored)
   LD [M]  fs/logfs/logfs.o
ld: fs/logfs/compr.o: No such file: No such file or 
directory
make[2]: [fs/logfs/logfs.o] Error 1 (ignored)
---
Professional hosting for everyone - http://www.host.ru
