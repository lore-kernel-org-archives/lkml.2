Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1IARRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:17:51 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:49931
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab1IARRs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:17:48 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2dK9371K542M1432N98dK14ffOzz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Mike Christie <michaelc@cs.wisc.edu>, Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dept_iscsi_driver <iscsi-driver@qlogic.com>
Date: Thu, 1 Sep 2011 10:17:40 -0700
Subject: RE: linux-next: Tree for Aug 30 (scsi/qla4xxx)
Thread-Topic: linux-next: Tree for Aug 30 (scsi/qla4xxx)
Thread-Index: AcxoUdQPYJ7b4kVvS+K+6ckf4Q+AZwAeQvdw
Message-ID: <5E4F49720D0BAD499EE1F01232234BA873C679F251@AVEXMB1.qlogic.org>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
 <20110831134515.049f584b.rdunlap@xenotime.net> <4E5EF3B4.90204@cs.wisc.edu>
In-Reply-To: <4E5EF3B4.90204@cs.wisc.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Mike Christie
> Sent: Wednesday, August 31, 2011 7:54 PM
> To: Randy Dunlap
> Cc: Stephen Rothwell; scsi; linux-next@vger.kernel.org; linux-kernel;
> Dept_iscsi_driver
> Subject: Re: linux-next: Tree for Aug 30 (scsi/qla4xxx)
>
> On 08/31/2011 03:45 PM, Randy Dunlap wrote:
> > On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:
> >
> >> Hi all,
> >
> > [Sorry about the delay.. slow build machine.
> > Please ignore if this is already known/fixed.]
> >
> >
> > (on i386)
> >
> > ERROR: "iscsi_boot_create_target" [drivers/scsi/qla4xxx/qla4xxx.ko]
> undefined!
> > ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/qla4xxx/qla4xxx.ko]
> undefined!
> > ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/qla4xxx/qla4xxx.ko]
> undefined!
> > ERROR: "iscsi_boot_create_initiator" [drivers/scsi/qla4xxx/qla4xxx.ko]
> undefined!
> > ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/qla4xxx/qla4xxx.ko]
> undefined!
> >
> > when CONFIG_ISCSI_BOOT_SYSFS is not enabled.
> >
>
>
> We need the attached patch.

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

