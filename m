Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0HRSb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:31:27 -0400
Received: from static-228-128-171-68.axsne.net ([68.171.128.228]:17730 "EHLO
	webmail.Tricoresolutions.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab0HRSb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:31:26 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2010 14:31:26 EDT
From: John Tomawski <jtomawski@Tricoresolutions.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Aug 2010 14:26:19 -0400
Subject: Debugging scsi connectivity issues with aic79xx module
Thread-Topic: Debugging scsi connectivity issues with aic79xx module
Thread-Index: Acs/AtnUVR9DVD9+QcmwW5hdj2rNug==
Message-ID: <0F204119DCA6C24895F2F4BF830D5EFD1E322FF78E@tcsex01.tricoresolutions.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To whom it may concern,

We are periodically losing connectivity to a scsi device, specifically a robot arm. The connectivity cannot be re-established until the machine is rebooted. The following error is listed in messages. We were using kernel version 2.6.18-128.

We have since installed version 2.6.18-194.11.1, and enabled 'options aic79xx aic79xx=verbose' in modprobe.conf.

Any assistance is greatly appreciated.

## Begin log information

Aug  5 06:12:14 host kernel: scsi3: Dumping Card State at program address 0x5 Mode 0x33
Aug  5 06:12:14 host kernel: Card was paused
Aug  5 06:12:14 host kernel: INTSTAT[0x0] SELOID[0x1] SELID[0x10] HS_MAILBOX[0x0]
Aug  5 06:12:14 host kernel: INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
Aug  5 06:12:14 host kernel: SCSISIGI[0x25] SCSIPHASE[0x1] SCSIBUS[0x0] LASTPHASE[0x1]
Aug  5 06:12:14 host kernel: SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]
Aug  5 06:12:14 host kernel: SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9802]
Aug  5 06:12:14 host kernel: KERNEL_QFREEZE_COUNT[0x9802] MK_MESSAGE_SCB[0xff00]
Aug  5 06:12:14 host kernel: MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x19]
Aug  5 06:12:14 host kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xa4]
Aug  5 06:12:14 host kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80] LQOSTAT0[0x0]
Aug  5 06:12:14 host kernel: LQOSTAT1[0x0] LQOSTAT2[0xe1]
Aug  5 06:12:14 host kernel:
Aug  5 06:12:14 host kernel: SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0x2 CURRSCB 0x3 NEXTSCB 0xff80
Aug  5 06:12:14 host kernel: qinstart = 1421 qinfifonext = 1421
Aug  5 06:12:14 host kernel: QINFIFO:
Aug  5 06:12:14 host kernel: WAITING_TID_QUEUES:
Aug  5 06:12:14 host kernel: Pending list:
Aug  5 06:12:14 host kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x17]
Aug  5 06:12:14 host kernel:   2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x17]
Aug  5 06:12:14 host kernel: Total 2
Aug  5 06:12:14 host kernel: Kernel Free SCB list: 1 0
Aug  5 06:12:14 host kernel: Sequencer Complete DMA-inprog list:
Aug  5 06:12:14 host kernel: Sequencer Complete list:
Aug  5 06:12:14 host kernel: Sequencer DMA-Up and Complete list:
Aug  5 06:12:14 host kernel: Sequencer On QFreeze and Complete list:
Aug  5 06:12:14 host kernel:
Aug  5 06:12:14 host kernel:
Aug  5 06:12:14 host kernel: scsi3: FIFO0 Free, LONGJMP == 0x8272, SCB 0x2
Aug  5 06:12:14 host kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
Aug  5 06:12:14 host kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Aug  5 06:12:14 host kernel: SOFFCNT[0x5] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Aug  5 06:12:14 host kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Aug  5 06:12:14 host kernel:
Aug  5 06:12:14 host kernel: scsi3: FIFO1 Free, LONGJMP == 0x8282, SCB 0x3
Aug  5 06:12:14 host kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
Aug  5 06:12:14 host kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Aug  5 06:12:14 host kernel: SOFFCNT[0x5] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Aug  5 06:12:14 host kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Aug  5 06:12:14 host kernel: LQIN: 0x8 0x0 0x0 0x2 0x0 0x1 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Aug  5 06:12:14 host kernel: scsi3: LQISTATE = 0x1, LQOSTATE = 0x0, OPTIONMODE = 0x52
Aug  5 06:12:14 host kernel: scsi3: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x2
Aug  5 06:12:14 host kernel: scsi3: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Aug  5 06:12:14 host kernel: SIMODE0[0xc]
Aug  5 06:12:14 host kernel: CCSCBCTL[0x4]
Aug  5 06:12:14 host kernel: scsi3: REG0 == 0x3, SINDEX = 0x104, DINDEX = 0x104
Aug  5 06:12:14 host kernel: scsi3: SCBPTR == 0x3, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xfffe
Aug  5 06:12:14 host kernel: CDB b8 14 2 40 0 2
Aug  5 06:12:14 host kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Aug  5 06:12:14 host kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Aug  5 06:12:14 host kernel: (scsi3:A:1:0): Device is disconnected, re-queuing SCB
Aug  5 06:12:14 host kernel: scsi3: Recovery code sleeping
Aug  5 06:12:19 host kernel: scsi3: Timer Expired (active 1)
Aug  5 06:12:19 host kernel: Recovery code awake
Aug  5 06:12:19 host kernel: scsi3: Command abort returning 0x2003
Aug  5 06:12:19 host kernel: st 3:0:1:0: Attempting to queue a TARGET RESET message:CDB: 0xa 0x0 0x1 0x0 0x0 0x0
Aug  5 06:12:19 host kernel: scsi3: Device reset code sleeping
Aug  5 06:12:24 host kernel: scsi3: Device reset timer expired (active 2)
Aug  5 06:12:24 host kernel: scsi3: Device reset returning 0x2003
Aug  5 06:12:24 host kernel: scsi 3:0:1:1: Attempting to queue a TARGET RESET message:CDB: 0xb8 0x14 0x2 0x40 0x0 0x2 0x0 0x0
 0x2 0x10 0x0 0x0
Aug  5 06:12:24 host kernel: scsi3: Device reset code sleeping
Aug  5 06:12:29 host kernel: scsi3: Device reset timer expired (active 2)
Aug  5 06:12:29 host kernel: scsi3: Device reset returning 0x2003
Aug  5 06:12:29 host kernel: Recovery SCB completes
Aug  5 06:12:29 host last message repeated 2 times

## End log information

Result of 'cat /proc/scsi/scsi'

[root@host log]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 32 Lun: 00
  Vendor: DP       Model: BACKPLANE        Rev: 1.05
  Type:   Enclosure                        ANSI SCSI revision: 05
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: DELL     Model: PERC 6/i         Rev: 1.21
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi0 Channel: 02 Id: 01 Lun: 00
  Vendor: DELL     Model: PERC 6/i         Rev: 1.21
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: HP       Model: Ultrium 4-SCSI   Rev: B43H
  Type:   Sequential-Access                ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 01 Lun: 00
  Vendor: HP       Model: Ultrium 4-SCSI   Rev: B43H
  Type:   Sequential-Access                ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 01 Lun: 01
  Vendor: OVERLAND Model: NEO Series       Rev: 0120
  Type:   Medium Changer                   ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: DVD-ROM TS-L333A Rev: D100
  Type:   CD-ROM                           ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: Dell     Model: Virtual  CDROM   Rev: 123
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: Dell     Model: Virtual  Floppy  Rev: 123
  Type:   Direct-Access                    ANSI SCSI revision: 02

Thanks in advance,

John R. Tomawski
jtomawski@tricoresolutions.com


