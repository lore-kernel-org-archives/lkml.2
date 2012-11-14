Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab2KNPOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:14:17 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:58932
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932738Ab2KNPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:14:16 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 8
X-BigFish: VPS8(zz9371I936eI542M1432I4015Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz30ih95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Mike Turquette <mturquette@ti.com>,
        Josh Cartwright <josh.cartwright@ni.com>
CC: Soren Brinkmann <sorenb@xilinx.com>, Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, "arm@kernel.org" <arm@kernel.org>
Subject: RE: [PATCH v3] clk: Add support for fundamental zynq clks
Thread-Topic: [PATCH v3] clk: Add support for fundamental zynq clks
Thread-Index: AQHNwfZerQIcaxDB0ESd5uWNucSxQpfocLsAgAEAkkA=
Date: Wed, 14 Nov 2012 15:14:07 +0000
References: <20121113232648.GA19911@beefymiracle.amer.corp.natinst.com>
 <20121113235516.20034.31067@nucleus>
In-Reply-To: <20121113235516.20034.31067@nucleus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.24.192]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <e71b86f3-58fe-4785-9f9d-bbade8aa7afb@AM1EHSMHS013.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAEFEKKI022883



> -----Original Message-----
> From: Mike Turquette [mailto:mturquette@ti.com]
> Sent: Wednesday, November 14, 2012 12:55 AM
> To: Josh Cartwright; Michal Simek
> Cc: Soren Brinkmann; Rob Herring; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; John Linn; arm@kernel.org
> Subject: Re: [PATCH v3] clk: Add support for fundamental zynq clks
> 
> Quoting Josh Cartwright (2012-11-13 15:26:48)
> > Provide simplified models for the necessary clocks on the zynq-7000
> > platform.  Currently, the PLLs, the CPU clock network, and the basic
> > peripheral clock networks (for SDIO, SMC, SPI, QSPI, UART) are modelled.
> >
> > OF bindings are also provided and documented.
> >
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > ---
> > Michal-
> >
> > Here is a v3 with a fix for the problem Soren Brinkmann spotted.  Am I
> > correct that your current plan is to merge this into your tree?
> >
> > If so:
> >
> > Mike-
> >
> > Can we get your Acked-by on this one?
> >
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

Applied.

Thanks,
Michal




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
