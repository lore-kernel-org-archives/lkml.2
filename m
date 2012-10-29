Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2J2IAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:00:18 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:22472
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab2J2IAQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:00:16 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zz9371I542M1432I4015Izz1202h1d1ah1d2ahzz17326ah8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 2/5] zynq: use pl310 device tree bindings
Thread-Topic: [PATCH v4 2/5] zynq: use pl310 device tree bindings
Thread-Index: AQHNtWmotvpi+iPkIUWz4okGXuE+dpfP6+yg
Date: Mon, 29 Oct 2012 08:00:09 +0000
References: <cover.1351466765.git.josh.cartwright@ni.com>
 <a60818e7f2bf13cbc06b21bb3e3b0071539379ea.1351466765.git.josh.cartwright@ni.com>
In-Reply-To: <a60818e7f2bf13cbc06b21bb3e3b0071539379ea.1351466765.git.josh.cartwright@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <d9c47e1e-a6c8-4f84-b086-e83b1ed62b4b@CO1EHSMHS010.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Wednesday, October 24, 2012 12:34 AM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 2/5] zynq: use pl310 device tree bindings
> 
> The Zynq has a PL310 L2 cache controller.  Convert in-tree uses to using the
> device tree.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-ep107.dts           | 9 +++++++++
>  arch/arm/mach-zynq/common.c                | 9 +--------
>  arch/arm/mach-zynq/include/mach/zynq_soc.h | 4 ----
>  3 files changed, 10 insertions(+), 12 deletions(-)

Applied to http://git.xilinx.com/?p=linux-xlnx.git;a=shortlog;h=refs/heads/arm-next

Thanks,
Michal


