Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2J2H7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:59:53 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:20619
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab2J2H7w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:59:52 -0400
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
Subject: RE: [PATCH v4 1/5] zynq: use GIC device tree bindings
Thread-Topic: [PATCH v4 1/5] zynq: use GIC device tree bindings
Thread-Index: AQHNtWmpMWs5pY3/VkWJTSc0R6X6JpfP67hw
Date: Mon, 29 Oct 2012 07:59:46 +0000
References: <cover.1351466765.git.josh.cartwright@ni.com>
 <94010fc0a0094ef29dc87fbdb77507e379c5fe76.1351466765.git.josh.cartwright@ni.com>
In-Reply-To: <94010fc0a0094ef29dc87fbdb77507e379c5fe76.1351466765.git.josh.cartwright@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <4dc73182-4ae3-478e-9306-dbe1ff888388@VA3EHSMHS008.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Thursday, October 18, 2012 2:47 AM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 1/5] zynq: use GIC device tree bindings
> 
> The Zynq uses the cortex-a9-gic.  This eliminates the need to hardcode register
> addresses.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/boot/dts/zynq-ep107.dts           | 10 ++++++----
>  arch/arm/mach-zynq/common.c                |  7 ++++++-
>  arch/arm/mach-zynq/include/mach/zynq_soc.h |  2 --
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 

Applied to http://git.xilinx.com/?p=linux-xlnx.git;a=shortlog;h=refs/heads/arm-next

Thanks,
Michal


