Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0DZTgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:36:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38273 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754775Ab0DZTgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:36:04 -0400
Date: Mon, 26 Apr 2010 15:36:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: INFO: umount blocked for more than 120 seconds
In-Reply-To: <20100426090142.GB3704@swordfish.minsk.epam.com>
Message-ID: <Pine.LNX.4.44L0.1004261534520.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010, Sergey Senozhatsky wrote:

> Hello,
> MiniSD card mounted through the USB card reader.
> 
> .34-rc5-git6
> 
> kernel: [ 5746.170226] scsi12 : usb-storage 2-2:1.0
> kernel: [ 5747.174113] scsi scan: INQUIRY result too short (5), using 36
> kernel: [ 5747.174128] scsi 12:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
> kernel: [ 5747.180721] sd 12:0:0:0: Attached scsi generic sg2 type 0
> kernel: [ 5747.190490] sd 12:0:0:0: [sdb] 2012160 512-byte logical blocks: (1.03 GB/982 MiB)
> kernel: [ 5747.193398] sd 12:0:0:0: [sdb] Write Protect is off
> kernel: [ 5747.193403] sd 12:0:0:0: [sdb] Mode Sense: 00 06 00 00
> kernel: [ 5747.193406] sd 12:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 5747.207116] sd 12:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 5747.207125]  sdb: sdb1
> kernel: [ 5747.233099] sd 12:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 5747.233112] sd 12:0:0:0: [sdb] Attached SCSI removable disk
> kernel: [ 5758.495211] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> kernel: [ 6360.626229] INFO: task umount:4235 blocked for more than 120 seconds.
> kernel: [ 6360.626237] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Is this repeatable?

Can you do this with CONFIG_USB_DEBUG enabled?  And acquire a usbmon 
trace at the same time (see Documentation/usb/usbmon.txt)?

Alan Stern

