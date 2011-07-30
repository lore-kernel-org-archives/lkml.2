Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1G3BOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 21:14:23 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:37415 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752739Ab1G3BOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 21:14:21 -0400
Date: Fri, 29 Jul 2011 18:14:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andreas Hartmann <andihartmann@01019freenet.de>, acho@novell.com,
        huajun li <huajun.li.lee@gmail.com>
Cc: linux-kernel@vger.kernel.org, lud <linux-usb@vger.kernel.org>,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: Linux 3.0: broken ums_eneub6250
Message-Id: <20110729181418.fa4af78f.rdunlap@xenotime.net>
In-Reply-To: <j0um5s$4l4$1@ID-44327.news.uni-berlin.de>
References: <j0um5s$4l4$1@ID-44327.news.uni-berlin.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add linux-usb and usb-storage mailing lists]

On Fri, 29 Jul 2011 18:14:19 +0200 Andreas Hartmann wrote:

> Hello,
> 
> I get the following errors on loading a SD-card in a UB6250 card reader
> (the card is fine - it works with another machine as expected):
> 
> 
> Jul 29 18:06:38 pc kernel: [15229.729803] usb 1-1.1: new high speed USB
> device number 8 using ehci_hcd
> Jul 29 18:06:38 pc kernel: [15229.815963] usb 1-1.1: New USB device
> found, idVendor=0cf2, idProduct=6250
> Jul 29 18:06:38 pc kernel: [15229.815969] usb 1-1.1: New USB device
> strings: Mfr=1, Product=2, SerialNumber=4
> Jul 29 18:06:38 pc kernel: [15229.815973] usb 1-1.1: Product: UB6250
> Jul 29 18:06:38 pc kernel: [15229.815977] usb 1-1.1: Manufacturer: ENE
> Flash
> Jul 29 18:06:38 pc kernel: [15229.815980] usb 1-1.1: SerialNumber:
> 606569746801
> Jul 29 18:06:38 pc mtp-probe: checking bus 1, device 8:
> "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1"
> Jul 29 18:06:38 pc mtp-probe: bus: 1, device: 8 was not an MTP device
> Jul 29 18:06:38 pc kernel: [15229.824527] scsi11 : usb-storage 1-1.1:1.0
> Jul 29 18:06:38 pc kernel: [15229.825206] usbcore: registered new
> interface driver ums_eneub6250
> Jul 29 18:06:39 pc kernel: [15230.827862] scsi scan: INQUIRY result too
> short (5), using 36
> Jul 29 18:06:39 pc kernel: [15230.827884] scsi 11:0:0:0: Direct-Access
>                                   PQ: 0 ANSI: 0
> Jul 29 18:06:39 pc kernel: [15230.828233] sd 11:0:0:0: Attached scsi
> generic sg2 type 0
> Jul 29 18:06:39 pc kernel: [15230.836748] sd 11:0:0:0: [sdb] Sector size
> 0 reported, assuming 512.
> Jul 29 18:06:39 pc kernel: [15230.836760] sd 11:0:0:0: [sdb] 1 512-byte
> logical blocks: (512 B/512 B)
> Jul 29 18:06:39 pc kernel: [15230.836766] sd 11:0:0:0: [sdb] 0-byte
> physical blocks
> Jul 29 18:06:39 pc kernel: [15230.839207] sd 11:0:0:0: [sdb] Write
> Protect is off
> Jul 29 18:06:39 pc kernel: [15230.839211] sd 11:0:0:0: [sdb] Mode Sense:
> 00 00 00 00
> Jul 29 18:06:39 pc kernel: [15230.840970] sd 11:0:0:0: [sdb] Asking for
> cache data failed
> Jul 29 18:06:39 pc kernel: [15230.840973] sd 11:0:0:0: [sdb] Assuming
> drive cache: write through
> Jul 29 18:06:39 pc kernel: [15230.844876] sd 11:0:0:0: [sdb] Sector size
> 0 reported, assuming 512.
> Jul 29 18:06:39 pc kernel: [15230.848697] sd 11:0:0:0: [sdb] Asking for
> cache data failed
> Jul 29 18:06:39 pc kernel: [15230.848700] sd 11:0:0:0: [sdb] Assuming
> drive cache: write through
> Jul 29 18:06:39 pc kernel: [15230.854173] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.854177] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.854181] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.854185] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.854189] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.854196] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.854200] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.859257] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.859260] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.859264] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.859268] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.859272] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.859279] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.859282] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.865106] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.865110] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.865115] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.865119] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.865124] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.865130] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.865134] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.870123] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.870127] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.870131] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.870134] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.870139] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.870145] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.870148] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.870159]
> ldm_validate_partition_table(): Disk read failed.
> Jul 29 18:06:39 pc kernel: [15230.874963] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.874969] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.874973] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.874977] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.874982] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.874989] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.874992] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.880316] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.880320] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.880324] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.880328] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.880333] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.880339] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.880343] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.885028] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.885031] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.885033] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.885036] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.885040] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.885045] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.885048] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.889818] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.889821] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.889824] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.889827] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.889832] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.889837] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.889840] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.895554] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.895558] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.895560] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.895563] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.895566] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.895571] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.895574] Buffer I/O error on device
> sdb, logical block 0
> Jul 29 18:06:39 pc kernel: [15230.900625] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.900628] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.900631] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.900633] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.900637] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.900642] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.905988] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.905991] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.905994] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.905996] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.905999] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.906004] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.906018]  sdb: unable to read partition
> table
> Jul 29 18:06:39 pc kernel: [15230.906021] sdb: partition table beyond
> EOD, enabling native capacity
> Jul 29 18:06:39 pc kernel: [15230.909618] sd 11:0:0:0: [sdb] Sector size
> 0 reported, assuming 512.
> Jul 29 18:06:39 pc kernel: [15230.913479] sd 11:0:0:0: [sdb] Incomplete
> mode parameter data
> Jul 29 18:06:39 pc kernel: [15230.913483] sd 11:0:0:0: [sdb] Assuming
> drive cache: write through
> Jul 29 18:06:39 pc kernel: [15230.920933] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.920938] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.920942] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.920947] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.920953] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.920962] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.925962] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.925965] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.925968] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.925970] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.925974] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.925979] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.930996] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.930999] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.931002] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.931006] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.931011] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.931017] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.937269] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.937276] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.937282] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.937290] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.937297] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.937312] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.937335]
> ldm_validate_partition_table(): Disk read failed.
> Jul 29 18:06:39 pc kernel: [15230.942345] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.942348] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.942352] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.942355] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.942364] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.942371] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.947077] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.947080] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.947084] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.947088] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.947092] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.947103] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.952084] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.952087] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.952090] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.952094] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.952098] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.952105] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.956705] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.956708] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.956712] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.956716] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.956720] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.956726] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.962327] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.962331] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.962335] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.962339] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.962343] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.962350] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.966681] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.966683] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.966687] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.966691] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.966694] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.966701] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.971546] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.971550] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.971554] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.971558] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.971564] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.971572] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.971604]  sdb: unable to read partition
> table
> Jul 29 18:06:39 pc kernel: [15230.971608] sdb: partition table beyond
> EOD, truncated
> Jul 29 18:06:39 pc kernel: [15230.976617] sd 11:0:0:0: [sdb] Sector size
> 0 reported, assuming 512.
> Jul 29 18:06:39 pc kernel: [15230.981532] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.981535] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.981539] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.981543] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.981548] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.981555] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.988112] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.988115] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.988119] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.988122] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.988127] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.988133] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15230.989882] sd 11:0:0:0: [sdb] Asking for
> cache data failed
> Jul 29 18:06:39 pc kernel: [15230.989885] sd 11:0:0:0: [sdb] Assuming
> drive cache: write through
> Jul 29 18:06:39 pc kernel: [15230.989888] sd 11:0:0:0: [sdb] Attached
> SCSI disk
> Jul 29 18:06:39 pc kernel: [15230.995364] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15230.995368] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15230.995371] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15230.995375] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15230.995379] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15230.995386] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15231.001494] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15231.001498] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15231.001502] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15231.001506] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15231.001512] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15231.001519] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15231.006152] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15231.006156] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15231.006159] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15231.006163] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15231.006167] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15231.006174] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15231.011298] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15231.011301] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15231.011304] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15231.011308] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15231.011313] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15231.011320] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:39 pc kernel: [15231.016450] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:39 pc kernel: [15231.016453] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:39 pc kernel: [15231.016457] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:39 pc kernel: [15231.016464] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:39 pc kernel: [15231.016468] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:39 pc kernel: [15231.016474] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.021214] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.021217] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.021221] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.021225] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.021229] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.021236] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.026391] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.026394] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.026397] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.026399] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.026403] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.026409] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.031674] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.031676] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.031679] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.031681] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.031684] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.031690] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.037098] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.037100] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.037103] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.037105] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.037108] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.037113] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.043700] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.043704] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.043708] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.043712] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.043716] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.043722] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.049106] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.049110] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.049114] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.049119] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.049125] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.049133] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.056314] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.056321] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.056325] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.056329] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.056335] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.056342] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.061091] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.061094] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.061097] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.061101] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.061105] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.061112] end_request: critical target
> error, dev sdb, sector 0
> Jul 29 18:06:40 pc kernel: [15231.066655] sd 11:0:0:0: [sdb] Unhandled
> sense code
> Jul 29 18:06:40 pc kernel: [15231.066660] sd 11:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> Jul 29 18:06:40 pc kernel: [15231.066665] sd 11:0:0:0: [sdb]  Sense Key
> : Medium Error [current]
> Jul 29 18:06:40 pc kernel: [15231.066670] sd 11:0:0:0: [sdb]  Add.
> Sense: Recorded entity not found
> Jul 29 18:06:40 pc kernel: [15231.066675] sd 11:0:0:0: [sdb] CDB:
> Read(10): 28 00 00 00 00 00 00 00 01 00
> Jul 29 18:06:40 pc kernel: [15231.066684] end_request: critical target
> error, dev sdb, sector 0
> 
> 
> Could anybody please take a look at this problem?
> 
> 
> Thank you,
> Andreas
> 
> 
>  lsusb -vs 8
> 
> Bus 001 Device 008: ID 0cf2:6250 ENE Technology, Inc. SD card reader
> (UB6250)
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0cf2 ENE Technology, Inc.
>   idProduct          0x6250 SD card reader (UB6250)
>   bcdDevice            1.00
>   iManufacturer           1 ENE Flash
>   iProduct                2 UB6250
>   iSerial                 4 606569746801
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           32
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              498mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      6
>       bInterfaceProtocol     80
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
> 
> 
> lspci -v
> 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller
> (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
>         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>         Kernel driver in use: agpgart-intel
> 
> 00:02.0 VGA compatible controller: Intel Corporation Core Processor
> Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0, IRQ 40
>         Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
>         Memory at e0000000 (64-bit, prefetchable) [size=256M]
>         I/O ports at e0e0 [size=8]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [d0] Power Management version 2
>         Capabilities: [a4] PCI Advanced Features
>         Kernel driver in use: i915
> 
> 00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series
> Chipset HECI Controller (rev 06)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at f6809000 (64-bit, non-prefetchable) [size=16]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Kernel driver in use: mei
> 
> 00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, medium devsel, latency 0, IRQ 16
>         Memory at f6807000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCI Advanced Features
>         Kernel driver in use: ehci_hcd
> 
> 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset
> High Definition Audio (rev 05)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0, IRQ 42
>         Memory at f6800000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
>         Capabilities: [100] Virtual Channel
>         Capabilities: [130] Root Complex Link
>         Kernel driver in use: HDA Intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 1 (rev 05) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 0000d000-0000dfff
>         Memory behind bridge: f5400000-f67fffff
>         Prefetchable memory behind bridge: 000000007c600000-000000007c7fffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Micro-Star International Co., Ltd.
> Device 1033
>         Capabilities: [a0] Power Management version 2
>         Kernel driver in use: pcieport
> 
> 00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 2 (rev 05) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=02, subordinate=04, sec-latency=0
>         I/O behind bridge: 0000c000-0000cfff
>         Memory behind bridge: f0400000-f2bfffff
>         Prefetchable memory behind bridge: 000000007c400000-000000007c5fffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Micro-Star International Co., Ltd.
> Device 1033
>         Capabilities: [a0] Power Management version 2
>         Kernel driver in use: pcieport
> 
> 00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 4 (rev 05) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>         I/O behind bridge: 0000b000-0000bfff
>         Memory behind bridge: f4000000-f53fffff
>         Prefetchable memory behind bridge: 000000007c200000-000000007c3fffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID)
> Device 0000
>         Capabilities: [a0] Power Management version 2
>         Kernel driver in use: pcieport
> 
> 00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI
> Express Root Port 6 (rev 05) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
>         I/O behind bridge: 0000a000-0000afff
>         Memory behind bridge: f2c00000-f3ffffff
>         Prefetchable memory behind bridge: 000000007c000000-000000007c1fffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Micro-Star International Co., Ltd.
> Device 1033
>         Capabilities: [a0] Power Management version 2
>         Kernel driver in use: pcieport
> 
> 00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset
> USB2 Enhanced Host Controller (rev 05) (prog-if 20 [EHCI])
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, medium devsel, latency 0, IRQ 23
>         Memory at f6806000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCI Advanced Features
>         Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
> (prog-if 01 [Subtractive decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=07, subordinate=07, sec-latency=32
>         Capabilities: [50] Subsystem: Micro-Star International Co., Ltd.
> Device 1033
> 
> 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC
> Interface Controller (rev 05)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, medium devsel, latency 0
>         Capabilities: [e0] Vendor Specific Information: Len=10 <?>
> 
> 00:1f.2 IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4
> port SATA IDE Controller (rev 05) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
>         I/O ports at e0d0 [size=8]
>         I/O ports at e0c0 [size=4]
>         I/O ports at e0b0 [size=8]
>         I/O ports at e0a0 [size=4]
>         I/O ports at e090 [size=16]
>         I/O ports at e080 [size=16]
>         Capabilities: [70] Power Management version 3
>         Capabilities: [b0] PCI Advanced Features
>         Kernel driver in use: ata_piix
> 
> 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus
> Controller (rev 05)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: medium devsel, IRQ 18
>         Memory at f6805000 (64-bit, non-prefetchable) [size=256]
>         I/O ports at e000 [size=32]
>         Kernel driver in use: i801_smbus
> 
> 00:1f.5 IDE interface: Intel Corporation 5 Series/3400 Series Chipset 2
> port SATA IDE Controller (rev 05) (prog-if 85 [Master SecO PriO])
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
>         I/O ports at e070 [size=8]
>         I/O ports at e060 [size=4]
>         I/O ports at e050 [size=8]
>         I/O ports at e040 [size=4]
>         I/O ports at e030 [size=16]
>         I/O ports at e020 [size=16]
>         Capabilities: [70] Power Management version 3
>         Capabilities: [b0] PCI Advanced Features
>         Kernel driver in use: ata_piix
> 
> 00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
> Series Chipset Thermal Subsystem (rev 05)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         Memory at f6804000 (64-bit, non-prefetchable) [size=4K]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Kernel driver in use: intel ips
> 
> 05:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
> Network Adapter (PCI-Express) (rev 01)
>         Subsystem: AzureWave Device 1089
>         Flags: bus master, fast devsel, latency 0, IRQ 19
>         Memory at f4000000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [60] Express Legacy Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
>         Capabilities: [170] Power Budgeting <?>
>         Kernel driver in use: ath9k
> 
> 06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0, IRQ 41
>         I/O ports at a000 [size=256]
>         Memory at f2c30000 (64-bit, prefetchable) [size=4K]
>         Memory at f2c20000 (64-bit, prefetchable) [size=64K]
>         Expansion ROM at f2c00000 [disabled] [size=128K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [70] Express Endpoint, MSI 01
>         Capabilities: [ac] MSI-X: Enable- Count=2 Masked-
>         Capabilities: [cc] Vital Product Data
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 01-00-00-00-ff-ff-00-00
>         Kernel driver in use: r8169
> 
> 3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture Generic Non-core Registers (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
> 
> 3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath
> Architecture System Address Decoder (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
> 
> 3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
> 
> 3f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0
> (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
> 
> 3f:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
> 
> 3f:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
>         Subsystem: Micro-Star International Co., Ltd. Device 1033
>         Flags: bus master, fast devsel, latency 0
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
