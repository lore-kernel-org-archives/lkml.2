Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab1FGGnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:43:22 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63201 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1FGGnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=at3i0NkeEciPYYT33HHJPeEYlFpwyVfP8BjJ14VptzFE1/vzHsin4jiRqeLqWpFR7G
         ciAF2DQFBOUiOgD7F2i+3mtDCRaxJvL9IypDwpHxkNXIjOj3WQo+je5k5gH0TUbKI/7v
         9dnwjyL5tVhKu1pCNPtGT+uphHMpDvQ63ZgIU=
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 10:43:20 +0400
Message-ID: <BANLkTikzwurphkXi9zHyCFKXiiH_uhfa5A@mail.gmail.com>
Subject: Kernel failure 2.6_2.6.32-31-amd64
From: Valentine Goloubev <tuxedo.live@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debian GNU/Linux 6.0.1

Kernel failure message 1:
------------[ cut here ]------------
WARNING: at /build/buildd-linux-2.6_2.6.32-31-amd64-vrfdM4/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/fs-writeback.c:588
writeback_inodes_wb+0x36b/0x4ff()
Hardware name:
Modules linked in: nls_utf8 isofs udf crc_itu_t acpi_cpufreq
cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_powersave
ppdev lp sco bridge stp bnep nouveau ttm rfcomm drm_kms_helper l2cap
drm i2c_algo_bit bluetooth rfkill binfmt_misc fuse loop
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
psmouse snd_seq snd_timer snd_seq_device i2c_i801 video snd i2c_core
soundcore serio_raw button pcspkr output evdev processor parport_pc
parport snd_page_alloc ext4 mbcache jbd2 crc16 usb_storage sg sr_mod
sd_mod crc_t10dif cdrom usbhid hid ata_generic ata_piix ehci_hcd
libata scsi_mod thermal thermal_sys usbcore nls_base e1000e [last
unloaded: scsi_wait_scan]
Pid: 1254, comm: flush-8:16 Not tainted 2.6.32-5-amd64 #1
Call Trace:
 [<ffffffff81108a83>] ? writeback_inodes_wb+0x36b/0x4ff
 [<ffffffff81108a83>] ? writeback_inodes_wb+0x36b/0x4ff
 [<ffffffff8104df00>] ? warn_slowpath_common+0x77/0xa3
 [<ffffffff81108a83>] ? writeback_inodes_wb+0x36b/0x4ff
 [<ffffffff81108d43>] ? wb_writeback+0x12c/0x1ab
 [<ffffffff8105a8d1>] ? del_timer_sync+0xc/0x16
 [<ffffffff812fb27c>] ? schedule_timeout+0xad/0xdd
 [<ffffffff81108edd>] ? wb_do_writeback+0x73/0x165
 [<ffffffff810c8fe6>] ? bdi_start_fn+0xbc/0xd2
 [<ffffffff810c8f2a>] ? bdi_start_fn+0x0/0xd2
 [<ffffffff81064bc9>] ? kthread+0x79/0x81
 [<ffffffff81011baa>] ? child_rip+0xa/0x20
 [<ffffffff81064b50>] ? kthread+0x0/0x81
 [<ffffffff81011ba0>] ? child_rip+0x0/0x20
---[ end trace d707836d1c477933 ]---



-- 
# Valentine "vig" Goloubev
# http://sites.google.com/site/tuxedolive/
