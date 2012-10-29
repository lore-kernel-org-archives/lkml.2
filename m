Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2J2HZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:25:23 -0400
Received: from [65.55.88.11] ([65.55.88.11]:10365 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750942Ab2J2HZW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:25:22 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 13
X-BigFish: VPS13(zz1454I1432I1418I4015Izz1202h1d1ah1d2ahzzz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v4 0/5] zynq subarch cleanups
Thread-Topic: [PATCH v4 0/5] zynq subarch cleanups
Thread-Index: AQHNtWmr0RZRheffW0uxuGWIfit9cJfP4Hrw
Date: Mon, 29 Oct 2012 07:24:16 +0000
References: <cover.1351466765.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351466765.git.josh.cartwright@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <5c2911d7-f753-4d9f-b8d8-3bf011d58e52@TX2EHSMHS014.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

 Michal-
> 
> Here is a v5 of the zynq cleanup patchset that addresses your feedback.  I've
> intentionally left patches 4 and 5 in the set until we figure out the appropriate
> way to get them in tree (feel free to just apply 1-3)

I am ok to pick just several patches from your patchset. But this is no definitely 
good working style. Not expert for submission process but I think that 
if there is one broken patch maintainer shouldn't apply it.
Can someone else check this?


> I've also moved the uart mapping in patch 5 to a known working address, until
> we can work out what is happening there.  This should allow this patchset to be
> applied and have the zc702 boot.

Will look at it and apply if works.
 
> You had suggested removing/renaming the zynq-ep107.dts; it wasn't clear
> whether you had wanted that in this patchset or not.  I'm going to assume not.
> I'll follow up with this, after this patchset is applied, if that works for you.

Not in this patchset. Sure feel free to send it.  

Thanks,
Michal


