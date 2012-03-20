Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab2CTIN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:13:58 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46296
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758648Ab2CTINx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:13:53 -0400
X-SpamScore: -8
X-BigFish: VS-8(zz1447M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/1] net: phylib: remove the length limitation of mii
 bus id
Thread-Topic: [PATCH 1/1] net: phylib: remove the length limitation of mii
 bus id
Thread-Index: AQHNBlBPCBO40YDo30GKfsUgrzatkZZzI5GA//+x2fA=
Date: Tue, 20 Mar 2012 08:13:47 +0000
Message-ID: <7FE21149F4667147B645348EC6057885146C9E@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1332217679-3703-1-git-send-email-b29396@freescale.com>
 <20120320075059.GA3849@pengutronix.de>
In-Reply-To: <20120320075059.GA3849@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.129]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > So changed to remove the bus id length limitation, a lot of handwork.
> 
> You might want to try 'coccinelle' [1] next time. This is a tool exactly for
> such kind of work. Already some basic knowledge can help you for a number of
> tasks.
>
Good tool.
Thanks for the info. :-)
 
> Regards,
> 
>    Wolfram
> 
> [1] http://en.wikipedia.org/wiki/Coccinelle_%28software%29
>

Regards
Dong Aisheng

