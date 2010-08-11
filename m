Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0HKXqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:46:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44872 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0HKXqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=VT2yyo4nPPUVrMzxF8O6oPIi09leOzs1wd5N1mUcPAIwa2wzGBi/zN7Jj8EnBVlOPp
         Ub1J8SUPDlv3L+de9OhJ4EGSfDsX75sfsDh4C0IvoJYT1w/Bad0eTH2uz1kYm2cD4fh6
         sZkG8QaqhqiH2hPesPjMemXNHUJM9zxMqxI0o=
MIME-Version: 1.0
From: Pistis Valentino <vale.pistis@gmail.com>
Date: Thu, 12 Aug 2010 01:46:27 +0200
Message-ID: <AANLkTimGwbP8_fachx9pwTyX1wZxxT1iGrKziWMmxunL@mail.gmail.com>
Subject: Problems Compile Misc Module Example
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm studying how to build kernel modules.
Right now I have found some strange errors and nothing solutions in the web.

I compiled my kernel module "driver_ase" whose files are driver_ase.h,
driver_ase.c.
No errors in compilation, the module is also loaded correctly.

I wrote a small service "service_ase.c" using the kernel module that I created.
I found a lot of errors.
the only explanation IMO is that the directory has been renamed  from
"/usr/src/linux-2.6.34.2/include/asm" in
"/usr/src/linux-2.6.34.2/include/asm-generic", the errors make me
think that some header file has not yet updated.

You may like this or something wrong?

Could you help me please?

I'm using Debian Sidux with 2.6.34.2 kernel compiled.

In the bottom of the mail has the source codes, and the error.
It is a bit long error message, sorry!

Ciao
Valentino

============== Error message ==============

user@siduxbox:~/LPSO/modules/driver_ase$ gcc -I
/usr/src/linux-2.6.34.2/include/ service_ase.c -o service_ase.out

In file included from driver_ase.h:9,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/init.h:247: error: expected ‘=’,
‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘parse_early_param’
/usr/src/linux-2.6.34.2/include/linux/init.h:248: error: expected ‘=’,
‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘parse_early_options’
In file included from /usr/src/linux-2.6.34.2/include/linux/list.h:6,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:9,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/prefetch.h:14:27: error:
asm/processor.h: No such file or directory
/usr/src/linux-2.6.34.2/include/linux/prefetch.h:15:23: error:
asm/cache.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/module.h:9,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/list.h:7:24: error:
asm/system.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/cache.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:12,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/kernel.h:720:2: warning:
#warning Attempt to use kernel headers from user space, see http:
In file included from /usr/src/linux-2.6.34.2/include/linux/preempt.h:9,
                 from /usr/src/linux-2.6.34.2/include/linux/spinlock.h:50,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/thread_info.h:26: error:
expected specifier-qualifier-list before ‘u32’
/usr/src/linux-2.6.34.2/include/linux/thread_info.h:40: error:
expected specifier-qualifier-list before ‘u64’
In file included from /usr/src/linux-2.6.34.2/include/linux/thread_info.h:55,
                 from /usr/src/linux-2.6.34.2/include/linux/preempt.h:9,
                 from /usr/src/linux-2.6.34.2/include/linux/spinlock.h:50,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/bitops.h:17:24: error:
asm/bitops.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/thread_info.h:55,
                 from /usr/src/linux-2.6.34.2/include/linux/preempt.h:9,
                 from /usr/src/linux-2.6.34.2/include/linux/spinlock.h:50,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/bitops.h:147: error: expected
‘)’ before ‘word’
/usr/src/linux-2.6.34.2/include/linux/bitops.h:153:2: error: #error
BITS_PER_LONG not 32 or 64
In file included from /usr/src/linux-2.6.34.2/include/linux/preempt.h:9,
                 from /usr/src/linux-2.6.34.2/include/linux/spinlock.h:50,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/thread_info.h:56:29: error:
asm/thread_info.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/preempt.h:10,
                 from /usr/src/linux-2.6.34.2/include/linux/spinlock.h:50,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/linkage.h:5:25: error:
asm/linkage.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/spinlock.h:386:24: error:
asm/atomic.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/spinlock.h:395: error: expected
‘)’ before ‘*’ token
In file included from /usr/src/linux-2.6.34.2/include/linux/nodemask.h:93,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:16,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_zero’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:156: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:156: error: (Each
undeclared identifier is reported only once
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:156: error: for each
function it appears in.)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_fill’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:167: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_copy’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:177: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_and’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:188: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_or’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:196: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_xor’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:205: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_andnot’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:214: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_complement’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:222: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_equal’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:231: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_intersects’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:240: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_subset’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:249: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_empty’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:257: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_full’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:265: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_weight’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:273: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function
‘bitmap_shift_right’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:281: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/bitmap.h: In function ‘bitmap_shift_left’:
/usr/src/linux-2.6.34.2/include/linux/bitmap.h:290: error:
‘BITS_PER_LONG’ undeclared (first use in this function)
In file included from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:16,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:96: error: expected
specifier-qualifier-list before ‘DECLARE_BITMAP’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__node_set’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:102: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__node_clear’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:108: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_setall’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:114: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_clear’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:120: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__node_test_and_set’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:130: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_and’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:138: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:138: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:138: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_or’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:146: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:146: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:146: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_xor’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:154: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:154: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:154: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_andnot’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:162: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:162: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:162: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodes_complement’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:170: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:170: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_equal’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:178: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:178: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodes_intersects’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:186: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:186: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_subset’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:194: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:194: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_empty’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:200: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_full’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:206: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_weight’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:212: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodes_shift_right’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:220: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:220: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodes_shift_left’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:228: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:228: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__first_node’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:237: error: expected
expression before ‘int’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__next_node’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:243: error: expected
expression before ‘int’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__first_unset_node’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:266: error: expected
expression before ‘int’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodemask_scnprintf’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:301: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodemask_parse_user’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:309: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodelist_scnprintf’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:317: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function
‘__nodelist_parse’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:323: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__node_remap’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:331: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:331: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_remap’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:339: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:339: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:339: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:339: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_onto’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:347: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:347: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:347: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h: In function ‘__nodes_fold’:
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:355: error:
‘nodemask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/nodemask.h:355: error:
‘nodemask_t’ has no member named ‘bits’
In file included from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h:20:22: error:
asm/page.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h:339: error: expected
specifier-qualifier-list before ‘atomic_long_t’
/usr/src/linux-2.6.34.2/include/linux/mmzone.h:628: error: expected
specifier-qualifier-list before ‘wait_queue_head_t’
In file included from /usr/src/linux-2.6.34.2/include/linux/notifier.h:13,
                 from /usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:6,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:642,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/mutex.h:50: error: expected
specifier-qualifier-list before ‘atomic_t’
/usr/src/linux-2.6.34.2/include/linux/mutex.h: In function ‘mutex_is_locked’:
/usr/src/linux-2.6.34.2/include/linux/mutex.h:118: error: ‘struct
mutex’ has no member named ‘count’
/usr/src/linux-2.6.34.2/include/linux/mutex.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/mutex.h:137: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘mutex_lock_interruptible’
/usr/src/linux-2.6.34.2/include/linux/mutex.h:138: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘mutex_lock_killable’
/usr/src/linux-2.6.34.2/include/linux/mutex.h:153: error: expected ‘)’
before ‘*’ token
In file included from /usr/src/linux-2.6.34.2/include/linux/notifier.h:14,
                 from /usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:6,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:642,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/rwsem.h:22:65: error:
asm/rwsem.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:6,
                 from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:642,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/notifier.h:62: error: field
‘rwsem’ has incomplete type
In file included from /usr/src/linux-2.6.34.2/include/linux/mmzone.h:642,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h: In function
‘mhp_notimplemented’:
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:182: error:
‘KERN_WARNING’ undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:182: error:
expected ‘)’ before string constant
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:205: error:
expected declaration specifiers or ‘...’ before ‘u64’
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:205: error:
expected declaration specifiers or ‘...’ before ‘u64’
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:206: error:
expected declaration specifiers or ‘...’ before ‘u64’
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:206: error:
expected declaration specifiers or ‘...’ before ‘u64’
/usr/src/linux-2.6.34.2/include/linux/memory_hotplug.h:207: error:
expected ‘)’ before ‘start’
In file included from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h: In function ‘populated_zone’:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h:675: error: ‘struct
zone’ has no member named ‘present_pages’
/usr/src/linux-2.6.34.2/include/linux/mmzone.h: In function ‘is_normal’:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h:724: error: ‘struct
zone’ has no member named ‘zone_pgdat’
In file included from /usr/src/linux-2.6.34.2/include/linux/gfp.h:4,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/mmzone.h:1083: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘node_memmap_size_bytes’
In file included from /usr/src/linux-2.6.34.2/include/linux/topology.h:30,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:13: error: expected
specifier-qualifier-list before ‘DECLARE_BITMAP’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_set_cpu’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:256: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_clear_cpu’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:266: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_test_and_set_cpu’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:288: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_test_and_clear_cpu’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:300: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_setall’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:309: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_clear’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:318: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_and’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:331: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:331: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:332: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_or’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:344: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:344: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:345: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_xor’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:358: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:358: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:359: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_andnot’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:372: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:372: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:373: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_complement’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:384: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:384: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:393: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cpumask_equal’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:405: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cpumask_intersects’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_subset’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:420: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:420: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:428: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cpumask_empty’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:437: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cpumask_full’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_weight’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:448: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_shift_right’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:460: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:460: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_shift_left’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:473: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:473: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpumask_copy’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:485: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:485: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_scnprintf’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:532: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpumask_parse_user’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:546: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘cpulist_scnprintf’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:561: error: ‘const
struct cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘cpulist_parse’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:575: error: ‘struct
cpumask’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:620: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘alloc_cpumask_var’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:625: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘alloc_cpumask_var_node’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:631: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘zalloc_cpumask_var’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:637: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘zalloc_cpumask_var_node’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:659: error: expected
‘)’ before numeric constant
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:670: error: expected
declaration specifiers or ‘...’ before ‘bool’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:671: error: expected
declaration specifiers or ‘...’ before ‘bool’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:672: error: expected
declaration specifiers or ‘...’ before ‘bool’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:673: error: expected
declaration specifiers or ‘...’ before ‘bool’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:705: error:
‘BITS_PER_LONG’ undeclared here (not in a function)
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:705: error: variably
modified ‘cpu_bit_bitmap’ at file scope
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpu_set’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:813: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpu_clear’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:819: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_setall’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:825: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_clear’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:831: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘__cpu_test_and_set’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:840: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_and’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:847: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:847: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:847: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_or’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:854: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:854: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:854: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_xor’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:861: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:861: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:861: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_andnot’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:869: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:869: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:869: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_equal’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:876: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:876: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘__cpus_intersects’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:883: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:883: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_subset’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:890: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:890: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_empty’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:896: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function ‘__cpus_weight’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:902: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h: In function
‘__cpus_shift_left’:
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:910: error:
‘cpumask_t’ has no member named ‘bits’
/usr/src/linux-2.6.34.2/include/linux/cpumask.h:910: error:
‘cpumask_t’ has no member named ‘bits’
In file included from /usr/src/linux-2.6.34.2/include/linux/topology.h:33,
                 from /usr/src/linux-2.6.34.2/include/linux/gfp.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/smp.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/smp.h:20: error: expected
specifier-qualifier-list before ‘u16’
In file included from /usr/src/linux-2.6.34.2/include/linux/gfp.h:7,
                 from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/topology.h:34:26: error:
asm/topology.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:121: error: expected ‘)’
before ‘gfp_flags’
In file included from /usr/src/linux-2.6.34.2/include/linux/kmod.h:22,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:185:2: error: #error
ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
/usr/src/linux-2.6.34.2/include/linux/gfp.h:216: error: expected ‘)’
before ‘flags’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:241: error: expected ‘)’
before ‘flags’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:258: error: expected
declaration specifiers or ‘...’ before ‘gfp_t’
/usr/src/linux-2.6.34.2/include/linux/gfp.h: In function ‘node_zonelist’:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:260: error: ‘flags’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/gfp.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:271: error: expected ‘)’
before ‘gfp_mask’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:275: error: expected ‘)’
before ‘gfp_mask’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:281: error: expected
declaration specifiers or ‘...’ before ‘gfp_t’
/usr/src/linux-2.6.34.2/include/linux/gfp.h: In function ‘alloc_pages_node’:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:288: error: ‘gfp_mask’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/gfp.h:288: error: too many
arguments to function ‘node_zonelist’
/usr/src/linux-2.6.34.2/include/linux/gfp.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:291: error: expected
declaration specifiers or ‘...’ before ‘gfp_t’
/usr/src/linux-2.6.34.2/include/linux/gfp.h: In function
‘alloc_pages_exact_node’:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:296: error: ‘gfp_mask’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/gfp.h:296: error: too many
arguments to function ‘node_zonelist’
/usr/src/linux-2.6.34.2/include/linux/gfp.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/gfp.h:316: error: expected ‘)’
before ‘gfp_mask’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:317: error: expected ‘)’
before ‘gfp_mask’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:319: error: expected
declaration specifiers or ‘...’ before ‘gfp_t’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:340: error: expected ‘=’,
‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘gfp_allowed_mask’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:342: error: expected ‘)’
before ‘mask’
/usr/src/linux-2.6.34.2/include/linux/gfp.h:343: error: expected ‘=’,
‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘clear_gfp_allowed_mask’
In file included from /usr/src/linux-2.6.34.2/include/linux/module.h:13,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/kmod.h:52: error: expected
declaration specifiers or ‘...’ before ‘gfp_t’
/usr/src/linux-2.6.34.2/include/linux/kmod.h: In function ‘call_usermodehelper’:
/usr/src/linux-2.6.34.2/include/linux/kmod.h:79: error: ‘gfp_t’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/kmod.h:79: error: expected ‘;’
before ‘gfp_mask’
/usr/src/linux-2.6.34.2/include/linux/kmod.h:81: error: ‘gfp_mask’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/kmod.h:81: error: too many
arguments to function ‘call_usermodehelper_setup’
/usr/src/linux-2.6.34.2/include/linux/kmod.h: In function
‘call_usermodehelper_keys’:
/usr/src/linux-2.6.34.2/include/linux/kmod.h:92: error: ‘gfp_t’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/kmod.h:92: error: expected ‘;’
before ‘gfp_mask’
/usr/src/linux-2.6.34.2/include/linux/kmod.h:94: error: ‘gfp_mask’
undeclared (first use in this function)
/usr/src/linux-2.6.34.2/include/linux/kmod.h:94: error: too many
arguments to function ‘call_usermodehelper_setup’
In file included from /usr/src/linux-2.6.34.2/include/linux/kobject.h:21,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:16,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/sysfs.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/sysfs.h:316: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘sysfs_init’
In file included from /usr/src/linux-2.6.34.2/include/linux/kobject.h:24,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:16,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/kref.h:21: error: expected
specifier-qualifier-list before ‘atomic_t’
In file included from /usr/src/linux-2.6.34.2/include/linux/module.h:16,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/kobject.h:37: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uevent_seqnum’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:77: error: expected
declaration specifiers or ‘...’ before ‘va_list’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:85: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kobject_add’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:88: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kobject_init_and_add’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:95: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kobject_create’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:96: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘kobject_create_and_add’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:99: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kobject_rename’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:100: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kobject_move’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:105: error: expected
declaration specifiers or ‘...’ before ‘gfp_t’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:162: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kset_register’
/usr/src/linux-2.6.34.2/include/linux/kobject.h:164: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kset_create_and_add’
/usr/src/linux-2.6.34.2/include/linux/kobject.h: In function ‘to_kset’:
/usr/src/linux-2.6.34.2/include/linux/kobject.h:170: error: expected
expression before ‘struct’
In file included from /usr/src/linux-2.6.34.2/include/linux/module.h:17,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/moduleparam.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/moduleparam.h:44: error:
expected specifier-qualifier-list before ‘u16’
In file included from /usr/src/linux-2.6.34.2/include/linux/rcupdate.h:42,
                 from /usr/src/linux-2.6.34.2/include/linux/tracepoint.h:18,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:18,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/completion.h:27: error: expected
specifier-qualifier-list before ‘wait_queue_head_t’
/usr/src/linux-2.6.34.2/include/linux/completion.h: In function
‘init_completion’:
/usr/src/linux-2.6.34.2/include/linux/completion.h:76: error: ‘struct
completion’ has no member named ‘wait’
/usr/src/linux-2.6.34.2/include/linux/completion.h: At top level:
/usr/src/linux-2.6.34.2/include/linux/completion.h:86: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘try_wait_for_completion’
/usr/src/linux-2.6.34.2/include/linux/completion.h:87: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘completion_done’
In file included from /usr/src/linux-2.6.34.2/include/linux/tracepoint.h:18,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:18,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/rcupdate.h:77:2: error: #error
"Unknown RCU implementation specified to kernel configuration"
In file included from /usr/src/linux-2.6.34.2/include/linux/tracepoint.h:18,
                 from /usr/src/linux-2.6.34.2/include/linux/module.h:18,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/rcupdate.h:372: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
/usr/src/linux-2.6.34.2/include/linux/rcupdate.h:391: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
In file included from /usr/src/linux-2.6.34.2/include/linux/module.h:20,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/percpu.h:10:24: error:
asm/percpu.h: No such file or directory
In file included from /usr/src/linux-2.6.34.2/include/linux/module.h:20,
                 from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/percpu.h:149: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘is_kernel_percpu_address’
/usr/src/linux-2.6.34.2/include/linux/percpu.h:154: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘setup_per_cpu_areas’
/usr/src/linux-2.6.34.2/include/linux/percpu.h:165: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘per_cpu_ptr_to_phys’
In file included from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/module.h:21:24: error:
asm/module.h: No such file or directory
In file included from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/module.h:565: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘is_module_address’
/usr/src/linux-2.6.34.2/include/linux/module.h:570: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘is_module_percpu_address’
/usr/src/linux-2.6.34.2/include/linux/module.h:575: error: expected
‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘is_module_text_address’
In file included from driver_ase.h:10,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/module.h:721: error: expected
‘;’, ‘,’ or ‘)’ before ‘*’ token
In file included from driver_ase.h:13,
                 from service_ase.c:18:
/usr/src/linux-2.6.34.2/include/linux/pid.h:59: error: expected
specifier-qualifier-list before ‘atomic_t’
/usr/src/linux-2.6.34.2/include/linux/pid.h: In function ‘get_pid’:
/usr/src/linux-2.6.34.2/include/linux/pid.h:78: error: ‘struct pid’
has no member named ‘count’
/usr/src/linux-2.6.34.2/include/linux/pid.h: In function ‘ns_of_pid’:
/usr/src/linux-2.6.34.2/include/linux/pid.h:139: error: ‘struct pid’
has no member named ‘numbers’
/usr/src/linux-2.6.34.2/include/linux/pid.h:139: error: ‘struct pid’
has no member named ‘level’
/usr/src/linux-2.6.34.2/include/linux/pid.h: In function ‘pid_nr’:
/usr/src/linux-2.6.34.2/include/linux/pid.h:158: error: ‘struct pid’
has no member named ‘numbers’
In file included from service_ase.c:18:
driver_ase.h: At top level:
driver_ase.h:31: warning: ‘struct inode’ declared inside parameter list
driver_ase.h:31: warning: its scope is only this definition or
declaration, which is probably not what you want
driver_ase.h:32: warning: ‘struct inode’ declared inside parameter list
driver_ase.h:35: warning: ‘struct inode’ declared inside parameter list


=========================================

=========== driver_ase.h ================
/*
 * A heder file for exporting functions and macros.
 *
 */

#ifndef DRIVER_ASE_DRIVER_ASE_H
#define DRIVER_ASE

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/pid.h>

#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <asm/ioctl.h>

MODULE_LICENSE ("Dual BSD/GPL");

#define ASE_DEVICE_NUMBER   "ase"
#define ASE_MINOR_NUMBER    253

#define ASE_IOCTL_GET_PID_PARENT    _IOR(ASE_MINOR_NUMBER, 0, long)
#define ASE_IOCTL_GET_PRIO_PARENT   _IOR(ASE_MINOR_NUMBER, 1, long)


void get_pid_parent (int *pid);
void get_prio_parent (int *pid);

static int ase_open (struct inode *inode, struct file *file);
static int ase_release (struct inode *inode, struct file *file);

static int ase_ioctl (struct inode *inode, struct file *filep,
        unsigned int ioctl_num, unsigned long ioctl_param);

#endif /* DRIVER_ASE_DRIVER_ASE_H */
===============================================================

============= driver_ase.c ==========================
/*
 * An example misc driver char device
 */

/*#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/pid.h>

#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <asm-generic/ioctl.h>
*/

#include "driver_ase.h"

MODULE_LICENSE ("Dual BSD/GPL");

#define ASE_DEVICE_NUMBER   "ase"
#define ASE_MINOR_NUMBER    253

#define ASE_IOCTL_GET_PID_PARENT    _IOR(ASE_MINOR_NUMBER, 0, long)
#define ASE_IOCTL_GET_PRIO_PARENT   _IOR(ASE_MINOR_NUMBER, 1, long)


void get_pid_parent (int *pid);
void get_prio_parent (int *pid);

static int ase_open (struct inode *inode, struct file *file);
static int ase_release (struct inode *inode, struct file *file);

static int ase_ioctl (struct inode *inode, struct file *filep,
        unsigned int ioctl_num, unsigned long ioctl_param);

/*
 * Special file operations for the device file
 */
static struct file_operations ase_fops =
{
    .owner = THIS_MODULE,
    .ioctl = ase_ioctl,
    .open = ase_open,
    .release = ase_release,
};

/*
 * A device driver instance
 */
static struct miscdevice ase_misc =
{
    .minor = 253,
    .name = "ase",
    .fops = &ase_fops,
};

/*
 * A counter for the file
 */
static int ase_opened = 0;

/*
 * Opening the file
 */
static int ase_open (struct inode *inode, struct file *file)
{
    printk("ase_open\n");

    if (ase_opened)  //only an access time
    {
        printk ("ase_open: BUSY\n");
        return -EBUSY;
    }

    ++ase_opened;
    return 0;
}

/*
 * Closing the file
 */
static int ase_release (struct inode *inode, struct file *file)
{
    printk ("ase_release\n");
    --ase_opened;
    return 0;
}

/*
 * Ioctl device
 */
static int ase_ioctl (struct inode *inode, struct file *filep,
        unsigned int ioctl_num, unsigned long ioctl_param)
{
    int rc = -EINVAL;
    printk ("ase_ioctl\n");

    switch (ioctl_num)
    {
        case ASE_IOCTL_GET_PID_PARENT:
            {
                get_pid_parent ((int *) ioctl_param);
                rc = 0;
                break;
            }
        case ASE_IOCTL_GET_PRIO_PARENT:
            {
                get_prio_parent ((int *) ioctl_param);
                rc = 0;
                break;
            }
        default:
            printk ("Undefined ioctl number: %d\n", ioctl_num);
    }
    return rc;
}

/*
 * Return the parent's pid of the pid passed as argument
 */
void get_pid_parent (int *pid)
{
    struct task_struct *p = pid_task(find_vpid(*pid), PIDTYPE_PID);
//thi is the actual method

    if (p)
        *pid = p->parent->pid;
    else
        printk ("Error: pid not exists!!\n");
}

/*
 * Return the parent's priority of teh passed as argument
 */
void get_prio_parent (int *pid)
{
    struct task_struct *p = pid_task(find_vpid(*pid), PIDTYPE_PID);
//thi is the actual method

    if (p)
        *pid = p->parent->prio;
    else
        printk ("Error: pid not exists!!\n");
}

/*
 * Init routine for the module
 */
static int ase_init (void)
{
	printk (KERN_ALERT "*********** REGISTER ASE DEVICE DRIVER **********\n");
    misc_register (&ase_misc); //the instance address of struct miscdevice

    return 0;

}

/*
 * Exit routine for the module
 */
static void ase_cleanup (void)
{
    misc_deregister(&ase_misc);
	printk (KERN_ALERT "*********** DEREGISTER ASE DEVICE DRIVER**********\n");
}

/*
 * Entry points init/exit module
 */
module_init (ase_init);
module_exit (ase_cleanup);
=======================================================

============= service_ase.c ==============================
/*
 * service_ase.c
 *
 * Example applicationo to use the driver_ase module driver.
 *
 * Usage: service [0|1] pid
 *      0: return the parent's pid of passed process;
 *      1: return the parent's priority of passed process;
 *      pid: the pid process we want pass to driver_ase
 *
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
#include "driver_ase.h"

#define ASE_DEVICE_FILE_NAME    "/dev/ase"

int main (int argc, char *argv[])
{
    int fd, pid, ret, service_num = 0;

    fd = open(ASE_DEVICE_FILE_NAME, O_RDONLY);
    if (fd == -1)
        return 0;

    service_num = atoi(argv[1]);
    pid = atoi(argv[2]);

    switch (service_num)
    {
        case 0:
        {
            ret = ioctl (fd, ASE_IOCTL_GET_PID_PARENT, &pid);
            if (ret == -EINVAL)
                return 0;

            printf ("Parent's PID = %d\n", pid);
            break;
        }
        case 1:
        {
            ret = ioctl (fd, ASE_IOCTL_GET_PRIO_PARENT, &pid);
            if (ret == -EINVAL)
                return 0;

            printf ("Parent's PRIORITY = %d\n", pid);
            break;
        }
        default:
            close (fd);
    };
    close (fd);
    return 0;
}
===================================================
