Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1LNLN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:13:59 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:3459
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab1LNLN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:13:58 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Kumar Gala <galak@kernel.crashing.org>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        Liu Shuo-B35362 <B35362@freescale.com>,
        "linux-kernel@vger.kernel.org Kernel" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH v2] Integrated Flash Controller support
Thread-Topic: [PATCH v2] Integrated Flash Controller support
Thread-Index: AQHMl7rmfBM38sjwhEqKYc31HdaBkJW6WI4AgAJGI4CACFWWgIAAAgYAgABC8ACAAHZOAIAVwFVg
Date: Wed, 14 Dec 2011 11:13:53 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F056964B0@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1320053901-23801-1-git-send-email-b35362@freescale.com>
	  <CCF7C6DB-437C-4140-894F-2F497AD610DC@kernel.crashing.org>
	  <8EDB3DC6-63E5-4D5C-BB52-15F32B85C5DD@kernel.crashing.org>
	 <1322602860.2150.10.camel@koala> <4ED5531C.6030104@freescale.com>
	 <EFF451D9-552A-4820-90D3-BF3156D5B25F@kernel.crashing.org>
 <1322643080.24797.413.camel@sauron.fi.intel.com>
In-Reply-To: <1322643080.24797.413.camel@sauron.fi.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.126]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBEBENVv001398

>-----Original Message-----
>From: Artem Bityutskiy [mailto:dedekind1@gmail.com]
>Sent: Wednesday, November 30, 2011 4:51 PM
>To: Kumar Gala
>Cc: Wood Scott-B07421; Li Yang-R58472; Liu Shuo-B35362; linux-
>kernel@vger.kernel.org Kernel; linux-mtd@lists.infradead.org; Andrew
>Morton; David Woodhouse; linuxppc-dev@lists.ozlabs.org list
>Subject: Re: [PATCH v2] Integrated Flash Controller support
>
>On Tue, 2011-11-29 at 19:47 -0600, Kumar Gala wrote:
>> As Scott said, I was more asking about the 2nd patch in the sequence
>> which did touch MTD.  Since that one is dependent on this patch,
>> wondering how we wanted to handle them.
>
>I do not have time to review it, but it looks OK, so I'd suggest to
>merge it vie the same tree as the rest of the patches.

Hi Artem,

So what is your suggestion on this patch?  Can we regard your previous email as an ACK and merge it through the powerpc tree?  Or do you prefer to merge them through the MTD tree with Kumar's ACK instead?

- Leo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
