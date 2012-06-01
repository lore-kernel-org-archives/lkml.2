Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab2FADrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:47:22 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17595 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758466Ab2FADrU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:47:20 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
X-SpamScore: -22
X-BigFish: VPS-22(zzbb2dI9371I936eK14ffI1432N98dK11f6N4015Izz1202hzz8275dhz2fh2a8h668h839h944he5bhf0ah)
From: Giridhar Malavali <giridhar.malavali@qlogic.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Arun Easi <arun.easi@qlogic.com>, Avik Shau <avik.shau@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Date: Thu, 31 May 2012 20:47:17 -0700
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.4+ merge window
Thread-Topic: [GIT PULL] Final round of SCSI updates for the 3.4+ merge
 window
Thread-Index: Ac0/qTtyzWtvcz34QrKWSsphGA4CGA==
Message-ID: <CBED88EA.47E61%giridhar.malavali@qlogic.com>
In-Reply-To: <1338494279.30470.461.camel@haakon2.linux-iscsi.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.14.0.111121
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas and all others,

I would like to thank you very much on behalf of QLogic Linux FC/FCoE team
to everyone who worked with us to get QLogic >= 24xx initial target driver
upstream for 3.5-rc1. You responded quickly to our queries and provided
the support to get this functionality delivered on time. We would like to
work further to get other target related functionalities upstream in
future. 

Thanks,
Giridhar


On 5/31/12 12:57 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>On Thu, 2012-05-31 at 13:17 +0100, James Bottomley wrote:
>> This is primarily another round of driver updates (bnx2fc, qla2xxx,
>> qla4xxx) including the target mode driver for qla2xxx.
>
>Hi everyone,
>
>With the Qlogic >= 24xx series HW target driver code now upstream for
>3.5-rc1, I wanted to take this brief moment to thank those who have
>contributed to reaching this initial milestone:
>
>Andrew Vasquez (Qlogic)
>Arun Easi (Qlogic)
>Chad Dupuis (Qlogic)
>Giridhar Malavali (Qlogic)
>Joern Engel (Pure)
>John 'Coz' Colgrove (Pure)
>Marco Sanvido (Pure)
>Patrick Lee (Pure)
>Roland Dreier (Pure)
>Scott Dietzen (Pure)
>Steve Hodgson (Pure)
>Jerome Martin (RisingTide)
>Madhu Iyengar (RisingTide)
>Marc Fleischmann (RisingTide)
>Christoph Hellwig (LSF / RTS)
>Andy Grover (RHAT)
>Dan Carpenter (Oracle)
>Hannes Reinecke (Suse.de)
>James Bottomley (Parallels)
>Stephen Rothwell (IBM)
>Vladislav Bolkhovitin (SCST / ID7)
>
>Without the help and support of these people the initial merge for
>v3.5-rc1 would not have been possible.
>
>Thank you!
>
>--nab
>
>


