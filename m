Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab2J2IBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:01:06 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:28887
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757633Ab2J2IBC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:01:02 -0400
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
Subject: RE: [PATCH v4 5/5] zynq: move static peripheral mappings
Thread-Topic: [PATCH v4 5/5] zynq: move static peripheral mappings
Thread-Index: AQHNtWmqbGUBUplIMkKe0WryExNYzpfP7CaA
Date: Mon, 29 Oct 2012 08:00:57 +0000
References: <cover.1351466765.git.josh.cartwright@ni.com>
 <7a663040dc05b79262d7bd8bf8224ca49eb00162.1351466765.git.josh.cartwright@ni.com>
In-Reply-To: <7a663040dc05b79262d7bd8bf8224ca49eb00162.1351466765.git.josh.cartwright@ni.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <736cec0d-a996-4cc9-95af-7912b372fb8c@CH1EHSMHS010.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Monday, October 22, 2012 4:16 AM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 5/5] zynq: move static peripheral mappings
>
> Shifting them up into the vmalloc region prevents the following warning, when
> booting a zynq qemu target with more than 512mb of RAM:
>
>   BUG: mapping for 0xe0000000 at 0xe0000000 out of vmalloc space
>
> In addition, it allows for reuse of these mappings when the proper drivers issue
> requests via ioremap().
>
> There are currently unknown issues with the early uart mapping.  For now, the
> uart will be mapped to a known working address.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-zynq/common.c                |  6 +++---
>  arch/arm/mach-zynq/include/mach/zynq_soc.h | 25 +++++++++++++++----------
>  2 files changed, 18 insertions(+), 13 deletions(-)
>

Tested and applied to http://git.xilinx.com/?p=linux-xlnx.git;a=shortlog;h=refs/heads/arm-next

Thanks,
Michal




This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


