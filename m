Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0FNQ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:29:32 -0400
Received: from kroah.org ([198.145.64.141]:56631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab0FNQ3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:29:31 -0400
Date: Mon, 14 Jun 2010 09:20:02 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on
 Linux-2.6.xx
Message-ID: <20100614162002.GA13902@kroah.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:16:29PM +0800, Jeff Chua wrote:
> Hi,
> 
> I just buy an e-SATA ExpressCard and trying on my notebook. It's able
> to see the external SATA harddisk. On initial boot, I'm seeing the
> following OOPS.
> 
> 
> 2010-06-14T16:43:21.077256+08:00 boston kernel: scsi 6:0:0:0:
> Direct-Access     ATA      SAMSUNG MCCOE64G PS10 PQ: 0 ANSI: 5
> 2010-06-14T16:43:21.077258+08:00 boston kernel: sd 6:0:0:0: [sdb]
> 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
> 2010-06-14T16:43:21.077260+08:00 boston kernel: sd 6:0:0:0: Attached
> scsi generic sg1 type 0
> 2010-06-14T16:43:21.077261+08:00 boston kernel: sd 6:0:0:0: [sdb]
> Write Protect is off
> 2010-06-14T16:43:21.077264+08:00 boston kernel: sd 6:0:0:0: [sdb] Mode
> Sense: 00 3a 00 00
> 2010-06-14T16:43:21.077266+08:00 boston kernel: sd 6:0:0:0: [sdb]
> Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 2010-06-14T16:43:21.077267+08:00 boston kernel: sdb: sdb1
> 2010-06-14T16:43:21.077268+08:00 boston kernel: sd 6:0:0:0: [sdb]
> Attached SCSI disk
> 2010-06-14T16:43:21.077270+08:00 boston kernel: ------------[ cut here
> ]------------
> 2010-06-14T16:43:21.077272+08:00 boston kernel: WARNING: at
> fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
> 2010-06-14T16:43:21.077273+08:00 boston kernel: Hardware name: 5413FGA
> 2010-06-14T16:43:21.077276+08:00 boston kernel: sysfs: cannot create
> duplicate filename
> '/devices/pci0000:00/0000:00:1c.3/0000:05:00.0/slot'

This is a warning that you can ignore, it's been fixed in the latest
tree (2.6.35-rc3).

try that and see.

thanks,

greg k-h
