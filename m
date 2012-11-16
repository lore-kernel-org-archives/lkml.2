Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2KPQDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:03:09 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:57792
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab2KPQDI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:03:08 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zz1432I4015Izz1de0h1202h1d1ah1d2ahzzz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h15d0l1155h)
X-WSS-ID: 0MDL8KS-02-A5Q-02
X-M-MSG: 
From: "Huang, Shane" <Shane.Huang@amd.com>
To: Aaron Lu <aaron.lu@intel.com>, Robert Hancock <hancockrwd@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>
CC: Borislav Petkov <bp@amd64.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Huang, Shane" <Shane.Huang@amd.com>
Subject: RE: ata4.00: failed to get Identify Device Data, Emask 0x1
Thread-Topic: ata4.00: failed to get Identify Device Data, Emask 0x1
Thread-Index: AQHNrAgv5Iu+aHdxPUSB2JeAsougyJe8Z80AgAAi4oCAAjrnkIAuBumg
Date: Fri, 16 Nov 2012 16:02:45 +0000
Message-ID: <43EB3AB3EEFE8D43B525F4D2EAF507E107EF3D53@SCYBEXDAG04.amd.com>
References: <20121016144932.GA24044@aftab.osrc.amd.com>
 <20121016155824.00d5b618@pyramind.ukuu.org.uk>
 <20121016151830.GB24044@aftab.osrc.amd.com> <507E0C1A.1010705@intel.com>
 <507E392E.2010305@gmail.com> <507E5671.6070504@intel.com>
 <43EB3AB3EEFE8D43B525F4D2EAF507E107EA8AA9@SCYBEXDAG03.amd.com>
In-Reply-To: <43EB3AB3EEFE8D43B525F4D2EAF507E107EA8AA9@SCYBEXDAG03.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried word 78 bit 5(Hardware Feature Control) which does not work,
> it is 0 on my HDD sample with log 30h page 08h and DevSlp supported.
> 
> Seems that word 78 bit 5 is only the sufficient condition, not the
> essential condition. Do you guys have suggestion?

Eventually I received the confirmation from the DevSlp HDD vendor,
bit 5 should be and will be set in production drives with log 30h
page 08h supported. So I will submit a patch to use it instead.


Hi Jeff,

I don't know when I will receive some production drives to verify
my patch, are you okay if I submit my patch first without testing
so as to meet kernel 3.7 bug fix window?

Thanks,
Shane

