Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2KETAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:00:22 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:22097
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab2KETAU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:00:20 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 14:00:20 EST
X-Forefront-Antispam-Report: CIP:198.70.193.116;KIP:(null);UIP:(null);IPV:NLI;H:avcashub1.qlogic.com;RD:avcashub2.qlogic.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz9371I1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2ei2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh1155h)
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
CC: Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 5 Nov 2012 10:45:08 -0800
Subject: RE: [PATCH] drivers: ethernet: qlogic: qlge_dbg.c: Fixed a coding
 style issue
Thread-Topic: [PATCH] drivers: ethernet: qlogic: qlge_dbg.c: Fixed a coding
 style issue
Thread-Index: Ac27FB9HHU05sHdWSa2Kq9HoXspYUAAcMneg
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87744DA340F@AVEXMB1.qlogic.org>
References: <1352092292-4413-1-git-send-email-gmate.amit@gmail.com>
In-Reply-To: <1352092292-4413-1-git-send-email-gmate.amit@gmail.com>
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



>From: Kumar Amit Mehta [mailto:gmate.amit@gmail.com] 
>Sent: Sunday, November 04, 2012 9:12 PM
>To: Jitendra Kalsaria
>Cc: Ron Mercer; Dept-Eng Linux Driver; netdev; linux-kernel; kernel-janitors@vger.kernel.org
>Subject: [PATCH] drivers: ethernet: qlogic: qlge_dbg.c: Fixed a coding style issue
>
>checkpatch.pl throws error message for the current code. This patch fixes
>this coding style issue.
>
>Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
>---
> drivers/net/ethernet/qlogic/qlge/qlge_dbg.c |   16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)

Never seen these before with checkpatch.pl when we submitted changes.

Anyway thanks for your effort on fixing it.

Acked-by: Jitendra Kalsaria <Jitendra.kalsaria@qlogic.com>

