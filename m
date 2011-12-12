Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1LLRqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:46:03 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:6747
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab1LLRp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:58 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zz1447M1432Nzz1202hzz8275bh8275dhz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
X-FB-SS: 13,
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: Dept_Infinipath <Dept_Infinipath@qlogic.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 12 Dec 2011 09:45:16 -0800
Subject: RE: [PATCH] IB/ipath: Use kcalloc instead of kzalloc to allocate
 array
Thread-Topic: [PATCH] IB/ipath: Use kcalloc instead of kzalloc to allocate
 array
Thread-Index: Acy3OlJSd0CDHZUSTWG7mrgVotLAbwBuzYgg
Message-ID: <35AAF1E4A771E142979F27B51793A48888856EE839@AVEXMB1.qlogic.org>
References: <1322600880.1534.304.camel@localhost.localdomain>
In-Reply-To: <1322600880.1534.304.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBCHkZuv020705

> Subject: [PATCH] IB/ipath: Use kcalloc instead of kzalloc to allocate
> array
>
> The advantage of kcalloc is, that will prevent integer overflows which
> could
> result from the multiplication of number of elements and size and it is
> also
> a bit nicer to read.
>
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
