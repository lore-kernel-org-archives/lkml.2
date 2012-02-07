Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2BGSdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:33:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43800 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab2BGSdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:33:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_Zv6HkLLqEzNKRCfQ7EbMNEVe_hzbW+mHOnDAWLidOhMBQ@mail.gmail.com>
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
	<m2pqdr2tyq.fsf@bob.laptop.org>
	<CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com>
	<4F30E19B.9020503@intel.com>
	<CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
	<4F310529.4020101@intel.com>
	<CAAJw_ZsHwdvXuw+edXUfyGOSMOu5oUw3zX8nUryxJJiiZXzXKQ@mail.gmail.com>
	<CAAJw_Zup7Wg7FO95Z63e_sniu21gyzdCjcBNgsS0aw6MguDwLw@mail.gmail.com>
	<CAAJw_Zv6HkLLqEzNKRCfQ7EbMNEVe_hzbW+mHOnDAWLidOhMBQ@mail.gmail.com>
Date: Wed, 8 Feb 2012 02:33:51 +0800
Message-ID: <CAAJw_Zs7aET=vdy033bzuHwW==uS8AW78NSvD2L_hjU+Mzp-_w@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Chris Ball <cjb@laptop.org>, Pierre Ossman <pierre@ossman.eu>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        arindam.nath@amd.com, zhangfei.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 12:07 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:

Help! I was trying Linux-3.0 on the SD and formatted it and now the SD
is dead! How can I recover it?

# with the SD plugged into to a USD reader ...

Initializing USB Mass Storage driver...
scsi21 : usb-storage 2-1.2:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 21:0:0:0: Direct-Access              USB Reader       0001 PQ: 0
ANSI: 0 CCS
sd 21:0:0:0: Attached scsi generic sg1 type 0
sd 21:0:0:0: [sdb] Attached SCSI removable disk

#  fdisk /dev/sdb
fdisk: unable to open /dev/sdb: No medium found



Thanks,
Jeff
