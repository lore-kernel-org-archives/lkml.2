Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3AECUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:20:43 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:27331
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab3AECUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:20:41 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
X-WSS-ID: 0MG4RUB-01-C6N-02
X-M-MSG: 
From: "Huang, Shane" <Shane.Huang@amd.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        "Huang, Shane" <Shane.Huang@amd.com>
Subject: RE: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data,
 Emask 0x1
Thread-Topic: [3.8-{rc1,rc2}] ata1.00: failed to get Identify Device Data,
 Emask 0x1
Thread-Index: AQHN6pHLLI+J+/ZF2Ei4qcz2gokWg5g4zacAgAAH+QCAASnakA==
Date: Sat, 5 Jan 2013 02:20:31 +0000
Message-ID: <43EB3AB3EEFE8D43B525F4D2EAF507E107F4160E@SCYBEXDAG04.amd.com>
References: <CA+icZUUCB3K1=DuM6Nonu+Qc+qg3cM_ODk9TDZ-uYCfLVOhrdw@mail.gmail.com>
	<CA+icZUXrQ4aq+cKXj3qEwnhtTGPBfHcJ6q_zTm3xSBUUh9W8dQ@mail.gmail.com>
 <CA+icZUVBdsAa7ZA7e_UNpBsAOpVOXcawhUncbHNdkC-MGY4qLw@mail.gmail.com>
In-Reply-To: <CA+icZUVBdsAa7ZA7e_UNpBsAOpVOXcawhUncbHNdkC-MGY4qLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r052Kuns017145

> OK, I see the patch I mentioned to fix the problem was later reverted [1].
> The real fix is "libata: replace sata_settings with devslp_timing" [2].

Yes, please use [2] which can also be found in kernel bugzilla #51881
and is pending on Jeff's acceptance. Sorry for the trouble to you guys.

Thanks,
Shane
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
