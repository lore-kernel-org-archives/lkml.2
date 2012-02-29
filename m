Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab2B2LeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:34:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39741 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2B2LeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:34:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.217.137 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330515400.3545.100.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Wed, 29 Feb 2012 13:36:40 +0200
In-Reply-To: <1330515322.3545.99.camel@sauron.fi.intel.com>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1330515322.3545.99.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-29pXm7z7P0GckQr/gA2M"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-29pXm7z7P0GckQr/gA2M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 13:35 +0200, Artem Bityutskiy wrote:
> On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> > The following patch set implements checkpointing support for
> > UBI. Checkpointing is an optional feature which stores the physical to
> > logical eraseblock relations in a checkpointing superblock to reduce
> > the initialization time of UBI. The current init time of UBI is
> > proportional to the number of physical erase blocks on the FLASH
> > device. With checkpointing enabled the scan time is limited to a fixed
> > number of blocks.
>=20
> Notice, your patch-set has huge amount of checkpatch.pl complaints -
> please fix them. This will also be consistent with the overall UBI
> coding style where I honored checkpatch.pl limitations like identation
> style and 80 chars per line.

Just for reference:

---------------------------------------------------------------------------=
-----

checkpatch.pl has some complaints:

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 1/7] MTD: UBI: Add checkpoint on-ch=
ip layout"

ERROR:TRAILING_WHITESPACE: trailing whitespace
#67: FILE: drivers/mtd/ubi/ubi-media.h:413:
+/* struct ubi_cp_hdr is followed by exactly three struct ub_cp_pool_* reco=
rds $

total: 1 errors, 0 warnings, 85 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 4/7] MTD: UBI: Make wl subsystem ch=
eckpoint aware"

WARNING:LONG_LINE: line over 80 characters
#83: FILE: drivers/mtd/ubi/wl.c:417:
+static struct ubi_wl_entry *find_early_wl_entry(struct rb_root *root, int =
max_pnum)

WARNING:LONG_LINE: line over 80 characters
#167: FILE: drivers/mtd/ubi/wl.c:578:
+       /* pool contains no free blocks, create a new one and write a check=
oint */

WARNING:LONG_LINE: line over 80 characters
#169: FILE: drivers/mtd/ubi/wl.c:580:
+               for (pool->size =3D 0; pool->size < pool->max_size; pool->s=
ize++) {

ERROR:TRAILING_WHITESPACE: trailing whitespace
#249: FILE: drivers/mtd/ubi/wl.c:819:
+^I/* This can happen if we recovered from a checkpoint the very $

total: 1 errors, 3 warnings, 287 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 5/7] MTD: UBI: Make process_eb() ch=
eckpoint aware"

WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statements=
 (8, 8)
#29: FILE: drivers/mtd/ubi/scan.c:1020:
+       if (vol_id > UBI_MAX_VOLUMES && vol_id !=3D UBI_LAYOUT_VOLUME_ID)
[...]
+       {

total: 0 errors, 1 warnings, 16 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 6/7] MTD: UBI: Implement checkpoint=
ing support"

WARNING:CONFIG_DESCRIPTION: please write a paragraph that describes the con=
fig symbol fully
#32: FILE: drivers/mtd/ubi/Kconfig:58:
+       help

ERROR:TRAILING_WHITESPACE: trailing whitespace
#154: FILE: drivers/mtd/ubi/checkpoint.c:100:
+^I$

WARNING:LONG_LINE: line over 80 characters
#159: FILE: drivers/mtd/ubi/checkpoint.c:105:
+/* Assigns a SEB to a given scan_volume and removes it from it's original =
list */

ERROR:TRAILING_WHITESPACE: trailing whitespace
#184: FILE: drivers/mtd/ubi/checkpoint.c:130:
+^I$

WARNING:LONG_LINE: line over 80 characters
#209: FILE: drivers/mtd/ubi/checkpoint.c:155:
+               if (be32_to_cpu(new_vh->sqnum) && seb->sqnum =3D=3D be32_to=
_cpu(new_vh->sqnum)) {

WARNING:LONG_LINE: line over 80 characters
#210: FILE: drivers/mtd/ubi/checkpoint.c:156:
+                       ubi_err("two LEBs with same sequence number %llu", =
seb->sqnum);

WARNING:LONG_LINE: line over 80 characters
#215: FILE: drivers/mtd/ubi/checkpoint.c:161:
+                       ubi_err("LEB on PEB %i is older than checkpoint?!",=
 seb->pnum);

WARNING:LONG_LINE: line over 80 characters
#220: FILE: drivers/mtd/ubi/checkpoint.c:166:
+               dbg_bld("Vol %i: Replacing LEB %i's PEB %i with PEB %i\n", =
sv->vol_id, seb->lnum, seb->pnum, new_seb->pnum);

WARNING:LONG_LINE: line over 80 characters
#241: FILE: drivers/mtd/ubi/checkpoint.c:187:
+       dbg_bld("Vol %i (type =3D %i): SEB %i is new, adding it!\n", sv->vo=
l_type, sv->vol_id, new_seb->lnum);

WARNING:LONG_LINE: line over 80 characters
#257: FILE: drivers/mtd/ubi/checkpoint.c:203:
+static int process_pool_seb(struct ubi_scan_info *si, struct ubi_vid_hdr *=
new_vh,

ERROR:TRAILING_WHITESPACE: trailing whitespace
#310: FILE: drivers/mtd/ubi/checkpoint.c:256:
+^I/* $

ERROR:TRAILING_WHITESPACE: trailing whitespace
#311: FILE: drivers/mtd/ubi/checkpoint.c:257:
+^I * Now scan all PEB in the pool to find changes which have been made $

WARNING:LONG_LINE: line over 80 characters
#321: FILE: drivers/mtd/ubi/checkpoint.c:267:
+                       dbg_bld("PEB %i in pool is no longer free, scanning=
 it! Vid %i", pnum, be32_to_cpu(vh->vol_id));

WARNING:LONG_LINE: line over 80 characters
#323: FILE: drivers/mtd/ubi/checkpoint.c:269:
+                       new_seb =3D kmem_cache_alloc(si->scan_leb_slab, GFP=
_KERNEL);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#350: FILE: drivers/mtd/ubi/checkpoint.c:296:
+^I^I$

ERROR:TRAILING_STATEMENTS: trailing statements should be on next line
#441: FILE: drivers/mtd/ubi/checkpoint.c:387:
+               if (cp_pos >=3D cp_size) goto out_si;

ERROR:TRAILING_WHITESPACE: trailing whitespace
#442: FILE: drivers/mtd/ubi/checkpoint.c:388:
+^I$

WARNING:LONG_LINE: line over 80 characters
#454: FILE: drivers/mtd/ubi/checkpoint.c:400:
+               dbg_bld("Found Volume %i! nused: %i\n", be32_to_cpu(cpvhdr-=
>vol_id), be32_to_cpu(cpvhdr->used_ebs));

ERROR:TRAILING_WHITESPACE: trailing whitespace
#485: FILE: drivers/mtd/ubi/checkpoint.c:431:
+^I^I^I$

WARNING:LONG_LINE: line over 80 characters
#486: FILE: drivers/mtd/ubi/checkpoint.c:432:
+                       /* Not good, a EBA entry points to a PEB which is n=
ot in our used list */

WARNING:LONG_LINE: line over 80 characters
#493: FILE: drivers/mtd/ubi/checkpoint.c:439:
+                       dbg_bld("Inserting pnum %i (leb %i) to vol %i", seb=
->pnum, seb->lnum, sv->vol_id);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#500: FILE: drivers/mtd/ubi/checkpoint.c:446:
+^I */  $

WARNING:LONG_LINE: line over 80 characters
#506: FILE: drivers/mtd/ubi/checkpoint.c:452:
+       if (scan_pool(ubi, si, cplpl->pebs, be32_to_cpu(cplpl->size), &max_=
sqnum2) < 0)

WARNING:LONG_LINE: line over 80 characters
#508: FILE: drivers/mtd/ubi/checkpoint.c:454:
+       if (scan_pool(ubi, si, cpspl->pebs, be32_to_cpu(cpspl->size), &max_=
sqnum2) < 0)

WARNING:LONG_LINE: line over 80 characters
#510: FILE: drivers/mtd/ubi/checkpoint.c:456:
+       if (scan_pool(ubi, si, cpupl->pebs, be32_to_cpu(cpupl->size), &max_=
sqnum2) < 0)

WARNING:LONG_LINE: line over 80 characters
#524: FILE: drivers/mtd/ubi/checkpoint.c:470:
+struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_s=
b_pnum)

ERROR:TRAILING_WHITESPACE: trailing whitespace
#580: FILE: drivers/mtd/ubi/checkpoint.c:526:
+^I}^I$

WARNING:LONG_LINE: line over 80 characters
#583: FILE: drivers/mtd/ubi/checkpoint.c:529:
+               ret =3D ubi_io_read_vid_hdr(ubi, be32_to_cpu(cpsb->block_lo=
c[i]), vh, 0);

WARNING:LONG_LINE: line over 80 characters
#585: FILE: drivers/mtd/ubi/checkpoint.c:531:
+                       ubi_err("Unable to read checkpoint block# %i (PEB: =
%i)", i, be32_to_cpu(cpsb->block_loc[i]));

WARNING:LONG_LINE: line over 80 characters
#606: FILE: drivers/mtd/ubi/checkpoint.c:552:
+                                 be32_to_cpu(cpsb->block_loc[i]), ubi->leb=
_start,

ERROR:TRAILING_WHITESPACE: trailing whitespace
#608: FILE: drivers/mtd/ubi/checkpoint.c:554:
+^I^I$

WARNING:LONG_LINE: line over 80 characters
#610: FILE: drivers/mtd/ubi/checkpoint.c:556:
+                       ubi_err("Unable to read checkpoint block# %i (PEB: =
%i)", i, be32_to_cpu(cpsb->block_loc[i]));

WARNING:LONG_LINE: line over 80 characters
#618: FILE: drivers/mtd/ubi/checkpoint.c:564:
+       data_crc =3D crc32_be(UBI_CRC32_INIT, cp_raw + sizeof(*cpsb), cp_si=
ze - sizeof(*cpsb));

ERROR:SPACING: space required before the open brace '{'
#619: FILE: drivers/mtd/ubi/checkpoint.c:565:
+       if (data_crc !=3D cpsb->data_crc){

ERROR:ELSE_AFTER_BRACE: else should follow close brace '}'
#649: FILE: drivers/mtd/ubi/checkpoint.c:595:
+               }
+               else {

ERROR:TRAILING_WHITESPACE: trailing whitespace
#687: FILE: drivers/mtd/ubi/checkpoint.c:633:
+^I$

ERROR:TRAILING_WHITESPACE: trailing whitespace
#730: FILE: drivers/mtd/ubi/checkpoint.c:676:
+^I$

WARNING:LONG_LINE: line over 80 characters
#831: FILE: drivers/mtd/ubi/checkpoint.c:777:
+               ubi_assert(vol->vol_type =3D=3D UBI_DYNAMIC_VOLUME || vol->=
vol_type =3D=3D UBI_STATIC_VOLUME);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#841: FILE: drivers/mtd/ubi/checkpoint.c:787:
+^I^I}^I^I$

ERROR:TRAILING_WHITESPACE: trailing whitespace
#852: FILE: drivers/mtd/ubi/checkpoint.c:798:
+^Iret =3D ubi_io_write_vid_hdr(ubi, new_cp->peb[0], svhdr);^I$

WARNING:LONG_LINE: line over 80 characters
#864: FILE: drivers/mtd/ubi/checkpoint.c:810:
+       cpsb->data_crc =3D crc32_be(UBI_CRC32_INIT, cp_raw + sizeof(*cpsb),=
 new_cp->size - sizeof(*cpsb));

WARNING:LONG_LINE: line over 80 characters
#869: FILE: drivers/mtd/ubi/checkpoint.c:815:
+               dbg_bld("Writing checkpoint data to PEB %i sqnum %llu\n", n=
ew_cp->peb[i], be64_to_cpu(dvhdr->sqnum));

WARNING:LONG_LINE: line over 80 characters
#872: FILE: drivers/mtd/ubi/checkpoint.c:818:
+                       ubi_err("Unable to write vid_hdr to PEB %i!\n", new=
_cp->peb[i]);

WARNING:LONG_LINE: line over 80 characters
#878: FILE: drivers/mtd/ubi/checkpoint.c:824:
+               ret =3D ubi_io_write(ubi, cp_raw + (i * ubi->leb_size), new=
_cp->peb[i], ubi->leb_start, ubi->leb_size);

WARNING:LONG_LINE: line over 80 characters
#880: FILE: drivers/mtd/ubi/checkpoint.c:826:
+                       ubi_err("Unable to write checkpoint to PEB %i!\n", =
new_cp->peb[i]);

WARNING:LONG_LINE: line over 80 characters
#927: FILE: drivers/mtd/ubi/checkpoint.c:873:
+                       ret =3D ubi_io_read_ec_hdr(ubi, old_cp->peb[0], ec_=
hdr, 0);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#957: FILE: drivers/mtd/ubi/checkpoint.c:903:
+^I^I^I^Ikfree(new_cp);^I^I^I$

ERROR:ELSE_AFTER_BRACE: else should follow close brace '}'
#963: FILE: drivers/mtd/ubi/checkpoint.c:909:
+               }
+               else

ERROR:CODE_INDENT: code indent should use tabs where possible
#992: FILE: drivers/mtd/ubi/checkpoint.c:938:
+       ^Inew_cp->used_blocks =3D new_cp->size / ubi->leb_size;$

WARNING:SPACE_BEFORE_TAB: please, no space before tabs
#992: FILE: drivers/mtd/ubi/checkpoint.c:938:
+       ^Inew_cp->used_blocks =3D new_cp->size / ubi->leb_size;$

WARNING:LEADING_SPACE: please, no spaces at the start of a line
#992: FILE: drivers/mtd/ubi/checkpoint.c:938:
+       ^Inew_cp->used_blocks =3D new_cp->size / ubi->leb_size;$

WARNING:LONG_LINE: line over 80 characters
#1011: FILE: drivers/mtd/ubi/checkpoint.c:957:
+                                       ubi_wl_put_cp_peb(ubi, new_cp->peb[=
i], 0);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1025: FILE: drivers/mtd/ubi/checkpoint.c:971:
+^I$

WARNING:LONG_LINE: line over 80 characters
#1040: FILE: drivers/mtd/ubi/ubi.h:613:
+struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_s=
b_pnum);

total: 21 errors, 33 warnings, 1006 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH 7/7] MTD: UBI: wire up checkpointin=
g"

ERROR:SWITCH_CASE_INDENT_LEVEL: switch and case should be at the same inden=
t
#21: FILE: drivers/mtd/ubi/build.c:153:
+       switch (ntype) {
+               case UBI_VOLUME_ADDED:
+               case UBI_VOLUME_REMOVED:
+               case UBI_VOLUME_RESIZED:
+               case UBI_VOLUME_RENAMED:

WARNING:LONG_LINE: line over 80 characters
#100: FILE: drivers/mtd/ubi/build.c:1001:
+       ubi->long_pool.used =3D ubi->long_pool.size =3D ubi->long_pool.max_=
size =3D ARRAY_SIZE(ubi->long_pool.pebs);

WARNING:LONG_LINE: line over 80 characters
#101: FILE: drivers/mtd/ubi/build.c:1002:
+       ubi->short_pool.used =3D ubi->short_pool.size =3D ubi->short_pool.m=
ax_size =3D ARRAY_SIZE(ubi->short_pool.pebs);

WARNING:LONG_LINE: line over 80 characters
#102: FILE: drivers/mtd/ubi/build.c:1003:
+       ubi->unk_pool.used =3D ubi->unk_pool.size =3D ubi->unk_pool.max_siz=
e =3D ARRAY_SIZE(ubi->unk_pool.pebs);

total: 1 errors, 3 warnings, 108 lines checked

---------------------------------------------------------------------------=
-----

checkpatch.pl results for the entire squashed patch-set

ERROR:TRAILING_WHITESPACE: trailing whitespace
#67: FILE: drivers/mtd/ubi/ubi-media.h:413:
+/* struct ubi_cp_hdr is followed by exactly three struct ub_cp_pool_* reco=
rds $

WARNING:LONG_LINE: line over 80 characters
#380: FILE: drivers/mtd/ubi/wl.c:417:
+static struct ubi_wl_entry *find_early_wl_entry(struct rb_root *root, int =
max_pnum)

WARNING:LONG_LINE: line over 80 characters
#464: FILE: drivers/mtd/ubi/wl.c:578:
+       /* pool contains no free blocks, create a new one and write a check=
oint */

WARNING:LONG_LINE: line over 80 characters
#466: FILE: drivers/mtd/ubi/wl.c:580:
+               for (pool->size =3D 0; pool->size < pool->max_size; pool->s=
ize++) {

ERROR:TRAILING_WHITESPACE: trailing whitespace
#546: FILE: drivers/mtd/ubi/wl.c:819:
+^I/* This can happen if we recovered from a checkpoint the very $

WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statements=
 (8, 8)
#651: FILE: drivers/mtd/ubi/scan.c:1020:
+       if (vol_id > UBI_MAX_VOLUMES && vol_id !=3D UBI_LAYOUT_VOLUME_ID)
[...]
+       {

WARNING:CONFIG_DESCRIPTION: please write a paragraph that describes the con=
fig symbol fully
#692: FILE: drivers/mtd/ubi/Kconfig:58:
+       help

ERROR:TRAILING_WHITESPACE: trailing whitespace
#814: FILE: drivers/mtd/ubi/checkpoint.c:100:
+^I$

WARNING:LONG_LINE: line over 80 characters
#819: FILE: drivers/mtd/ubi/checkpoint.c:105:
+/* Assigns a SEB to a given scan_volume and removes it from it's original =
list */

ERROR:TRAILING_WHITESPACE: trailing whitespace
#844: FILE: drivers/mtd/ubi/checkpoint.c:130:
+^I$

WARNING:LONG_LINE: line over 80 characters
#869: FILE: drivers/mtd/ubi/checkpoint.c:155:
+               if (be32_to_cpu(new_vh->sqnum) && seb->sqnum =3D=3D be32_to=
_cpu(new_vh->sqnum)) {

WARNING:LONG_LINE: line over 80 characters
#870: FILE: drivers/mtd/ubi/checkpoint.c:156:
+                       ubi_err("two LEBs with same sequence number %llu", =
seb->sqnum);

WARNING:LONG_LINE: line over 80 characters
#875: FILE: drivers/mtd/ubi/checkpoint.c:161:
+                       ubi_err("LEB on PEB %i is older than checkpoint?!",=
 seb->pnum);

WARNING:LONG_LINE: line over 80 characters
#880: FILE: drivers/mtd/ubi/checkpoint.c:166:
+               dbg_bld("Vol %i: Replacing LEB %i's PEB %i with PEB %i\n", =
sv->vol_id, seb->lnum, seb->pnum, new_seb->pnum);

WARNING:LONG_LINE: line over 80 characters
#901: FILE: drivers/mtd/ubi/checkpoint.c:187:
+       dbg_bld("Vol %i (type =3D %i): SEB %i is new, adding it!\n", sv->vo=
l_type, sv->vol_id, new_seb->lnum);

WARNING:LONG_LINE: line over 80 characters
#917: FILE: drivers/mtd/ubi/checkpoint.c:203:
+static int process_pool_seb(struct ubi_scan_info *si, struct ubi_vid_hdr *=
new_vh,

ERROR:TRAILING_WHITESPACE: trailing whitespace
#970: FILE: drivers/mtd/ubi/checkpoint.c:256:
+^I/* $

ERROR:TRAILING_WHITESPACE: trailing whitespace
#971: FILE: drivers/mtd/ubi/checkpoint.c:257:
+^I * Now scan all PEB in the pool to find changes which have been made $

WARNING:LONG_LINE: line over 80 characters
#981: FILE: drivers/mtd/ubi/checkpoint.c:267:
+                       dbg_bld("PEB %i in pool is no longer free, scanning=
 it! Vid %i", pnum, be32_to_cpu(vh->vol_id));

WARNING:LONG_LINE: line over 80 characters
#983: FILE: drivers/mtd/ubi/checkpoint.c:269:
+                       new_seb =3D kmem_cache_alloc(si->scan_leb_slab, GFP=
_KERNEL);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1010: FILE: drivers/mtd/ubi/checkpoint.c:296:
+^I^I$

ERROR:TRAILING_STATEMENTS: trailing statements should be on next line
#1101: FILE: drivers/mtd/ubi/checkpoint.c:387:
+               if (cp_pos >=3D cp_size) goto out_si;

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1102: FILE: drivers/mtd/ubi/checkpoint.c:388:
+^I$

WARNING:LONG_LINE: line over 80 characters
#1114: FILE: drivers/mtd/ubi/checkpoint.c:400:
+               dbg_bld("Found Volume %i! nused: %i\n", be32_to_cpu(cpvhdr-=
>vol_id), be32_to_cpu(cpvhdr->used_ebs));

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1145: FILE: drivers/mtd/ubi/checkpoint.c:431:
+^I^I^I$

WARNING:LONG_LINE: line over 80 characters
#1146: FILE: drivers/mtd/ubi/checkpoint.c:432:
+                       /* Not good, a EBA entry points to a PEB which is n=
ot in our used list */

WARNING:LONG_LINE: line over 80 characters
#1153: FILE: drivers/mtd/ubi/checkpoint.c:439:
+                       dbg_bld("Inserting pnum %i (leb %i) to vol %i", seb=
->pnum, seb->lnum, sv->vol_id);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1160: FILE: drivers/mtd/ubi/checkpoint.c:446:
+^I */  $

WARNING:LONG_LINE: line over 80 characters
#1166: FILE: drivers/mtd/ubi/checkpoint.c:452:
+       if (scan_pool(ubi, si, cplpl->pebs, be32_to_cpu(cplpl->size), &max_=
sqnum2) < 0)

WARNING:LONG_LINE: line over 80 characters
#1168: FILE: drivers/mtd/ubi/checkpoint.c:454:
+       if (scan_pool(ubi, si, cpspl->pebs, be32_to_cpu(cpspl->size), &max_=
sqnum2) < 0)

WARNING:LONG_LINE: line over 80 characters
#1170: FILE: drivers/mtd/ubi/checkpoint.c:456:
+       if (scan_pool(ubi, si, cpupl->pebs, be32_to_cpu(cpupl->size), &max_=
sqnum2) < 0)

WARNING:LONG_LINE: line over 80 characters
#1184: FILE: drivers/mtd/ubi/checkpoint.c:470:
+struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_s=
b_pnum)

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1240: FILE: drivers/mtd/ubi/checkpoint.c:526:
+^I}^I$

WARNING:LONG_LINE: line over 80 characters
#1243: FILE: drivers/mtd/ubi/checkpoint.c:529:
+               ret =3D ubi_io_read_vid_hdr(ubi, be32_to_cpu(cpsb->block_lo=
c[i]), vh, 0);

WARNING:LONG_LINE: line over 80 characters
#1245: FILE: drivers/mtd/ubi/checkpoint.c:531:
+                       ubi_err("Unable to read checkpoint block# %i (PEB: =
%i)", i, be32_to_cpu(cpsb->block_loc[i]));

WARNING:LONG_LINE: line over 80 characters
#1266: FILE: drivers/mtd/ubi/checkpoint.c:552:
+                                 be32_to_cpu(cpsb->block_loc[i]), ubi->leb=
_start,

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1268: FILE: drivers/mtd/ubi/checkpoint.c:554:
+^I^I$

WARNING:LONG_LINE: line over 80 characters
#1270: FILE: drivers/mtd/ubi/checkpoint.c:556:
+                       ubi_err("Unable to read checkpoint block# %i (PEB: =
%i)", i, be32_to_cpu(cpsb->block_loc[i]));

WARNING:LONG_LINE: line over 80 characters
#1278: FILE: drivers/mtd/ubi/checkpoint.c:564:
+       data_crc =3D crc32_be(UBI_CRC32_INIT, cp_raw + sizeof(*cpsb), cp_si=
ze - sizeof(*cpsb));

ERROR:SPACING: space required before the open brace '{'
#1279: FILE: drivers/mtd/ubi/checkpoint.c:565:
+       if (data_crc !=3D cpsb->data_crc){

ERROR:ELSE_AFTER_BRACE: else should follow close brace '}'
#1309: FILE: drivers/mtd/ubi/checkpoint.c:595:
+               }
+               else {

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1347: FILE: drivers/mtd/ubi/checkpoint.c:633:
+^I$

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1390: FILE: drivers/mtd/ubi/checkpoint.c:676:
+^I$

WARNING:LONG_LINE: line over 80 characters
#1491: FILE: drivers/mtd/ubi/checkpoint.c:777:
+               ubi_assert(vol->vol_type =3D=3D UBI_DYNAMIC_VOLUME || vol->=
vol_type =3D=3D UBI_STATIC_VOLUME);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1501: FILE: drivers/mtd/ubi/checkpoint.c:787:
+^I^I}^I^I$

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1512: FILE: drivers/mtd/ubi/checkpoint.c:798:
+^Iret =3D ubi_io_write_vid_hdr(ubi, new_cp->peb[0], svhdr);^I$

WARNING:LONG_LINE: line over 80 characters
#1524: FILE: drivers/mtd/ubi/checkpoint.c:810:
+       cpsb->data_crc =3D crc32_be(UBI_CRC32_INIT, cp_raw + sizeof(*cpsb),=
 new_cp->size - sizeof(*cpsb));

WARNING:LONG_LINE: line over 80 characters
#1529: FILE: drivers/mtd/ubi/checkpoint.c:815:
+               dbg_bld("Writing checkpoint data to PEB %i sqnum %llu\n", n=
ew_cp->peb[i], be64_to_cpu(dvhdr->sqnum));

WARNING:LONG_LINE: line over 80 characters
#1532: FILE: drivers/mtd/ubi/checkpoint.c:818:
+                       ubi_err("Unable to write vid_hdr to PEB %i!\n", new=
_cp->peb[i]);

WARNING:LONG_LINE: line over 80 characters
#1538: FILE: drivers/mtd/ubi/checkpoint.c:824:
+               ret =3D ubi_io_write(ubi, cp_raw + (i * ubi->leb_size), new=
_cp->peb[i], ubi->leb_start, ubi->leb_size);

WARNING:LONG_LINE: line over 80 characters
#1540: FILE: drivers/mtd/ubi/checkpoint.c:826:
+                       ubi_err("Unable to write checkpoint to PEB %i!\n", =
new_cp->peb[i]);

WARNING:LONG_LINE: line over 80 characters
#1587: FILE: drivers/mtd/ubi/checkpoint.c:873:
+                       ret =3D ubi_io_read_ec_hdr(ubi, old_cp->peb[0], ec_=
hdr, 0);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1617: FILE: drivers/mtd/ubi/checkpoint.c:903:
+^I^I^I^Ikfree(new_cp);^I^I^I$

ERROR:ELSE_AFTER_BRACE: else should follow close brace '}'
#1623: FILE: drivers/mtd/ubi/checkpoint.c:909:
+               }
+               else

ERROR:CODE_INDENT: code indent should use tabs where possible
#1652: FILE: drivers/mtd/ubi/checkpoint.c:938:
+       ^Inew_cp->used_blocks =3D new_cp->size / ubi->leb_size;$

WARNING:SPACE_BEFORE_TAB: please, no space before tabs
#1652: FILE: drivers/mtd/ubi/checkpoint.c:938:
+       ^Inew_cp->used_blocks =3D new_cp->size / ubi->leb_size;$

WARNING:LEADING_SPACE: please, no spaces at the start of a line
#1652: FILE: drivers/mtd/ubi/checkpoint.c:938:
+       ^Inew_cp->used_blocks =3D new_cp->size / ubi->leb_size;$

WARNING:LONG_LINE: line over 80 characters
#1671: FILE: drivers/mtd/ubi/checkpoint.c:957:
+                                       ubi_wl_put_cp_peb(ubi, new_cp->peb[=
i], 0);

ERROR:TRAILING_WHITESPACE: trailing whitespace
#1685: FILE: drivers/mtd/ubi/checkpoint.c:971:
+^I$

WARNING:LONG_LINE: line over 80 characters
#1700: FILE: drivers/mtd/ubi/ubi.h:613:
+struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_s=
b_pnum);

ERROR:SWITCH_CASE_INDENT_LEVEL: switch and case should be at the same inden=
t
#1731: FILE: drivers/mtd/ubi/build.c:153:
+       switch (ntype) {
+               case UBI_VOLUME_ADDED:
+               case UBI_VOLUME_REMOVED:
+               case UBI_VOLUME_RESIZED:
+               case UBI_VOLUME_RENAMED:

WARNING:LONG_LINE: line over 80 characters
#1810: FILE: drivers/mtd/ubi/build.c:1001:
+       ubi->long_pool.used =3D ubi->long_pool.size =3D ubi->long_pool.max_=
size =3D ARRAY_SIZE(ubi->long_pool.pebs);

WARNING:LONG_LINE: line over 80 characters
#1811: FILE: drivers/mtd/ubi/build.c:1002:
+       ubi->short_pool.used =3D ubi->short_pool.size =3D ubi->short_pool.m=
ax_size =3D ARRAY_SIZE(ubi->short_pool.pebs);

WARNING:LONG_LINE: line over 80 characters
#1812: FILE: drivers/mtd/ubi/build.c:1003:
+       ubi->unk_pool.used =3D ubi->unk_pool.size =3D ubi->unk_pool.max_siz=
e =3D ARRAY_SIZE(ubi->unk_pool.pebs);

total: 24 errors, 40 warnings, 1616 lines checked

---------------------------------------------------------------------------=
-----
[2012-02-29 13:23:49] test-patchset: Preserved tmpdir: /home/space/dedekind=
/aiaiai/test-patchset.kMgP

--=20
Best Regards,
Artem Bityutskiy

--=-29pXm7z7P0GckQr/gA2M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTg3IAAoJECmIfjd9wqK0kyAP/1DrM0DyRnlkVP33WG9sw01d
BzsMAhinKO4AneJRhf6ltFcJbC3eUUbhIl2R0fYZn+o+oxPDxSQsEFjsUOwN1sXj
8DycytF4OVWBTNTQD9cgWmteYq5E1zrJAaDZBhe6tsBXULolz9l8x/GJfzqu/YoZ
sJ0CoaNELyaQbyUpHOElevqiANERLiSAuwXm4DOS5q/jT3J+KEoTaVM/LcVJQBcC
FmnMuGZobrh8GSnq6ZhQQt2OSwB3FNCu7uu7tX9NLt9bWYKzY9nkuA3WmidpLDGU
I3cHTUxAgcReHG8oHjqL3cPlfOssj0vuwJHa0iSBEEh012y/kjwZzY6vutBEUM/1
BZeevn/e/gQ4JZyL5NAX5ed1NZFeakwzRoDwGNnLx5aDYP3l4Zt728cW/A1dOpkN
K+vAc6we3B4ZLkis9BRmD/CLnyySsPhRO/uRuW9iOvwcdxTLaxo/pNA/Z0BIEIv0
/69FpAHs25kJTBA/2kzsjDVmjH/gxyKsRcQthKW8Kb46O3fsH0Xcth2x9OcWa8s3
wwOlQjlj44aGInYhgNDlwB252yHEYAAvoZLhPxM81swaTj6QuRYGjr+djsgTzm3C
quqMrHX8+Bh+c3kBBMy1Cr2ZcG8YY056Z0/xPUGIg15RsyMqzQDug1iS435o8Qow
y8CXIb+D0UlMRPM0EhvM
=/xqv
-----END PGP SIGNATURE-----

--=-29pXm7z7P0GckQr/gA2M--

