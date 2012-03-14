Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab2CNHz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:55:59 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:53352
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131Ab2CNHz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:55:57 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F604F9F.1070801@freescale.com>
Date: Wed, 14 Mar 2012 15:58:23 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <vinod.koul@linux.intel.com>, <s.hauer@pengutronix.de>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <rdunlap@xenotime.net>, <kernel@pengutronix.de>, <cjb@laptop.org>,
        <shawn.guo@freescale.com>
Subject: Re: [PATCH v1 5/5] ARM: mxs: add mxs dma dt support
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <1331628428-24017-6-git-send-email-b29396@freescale.com>
In-Reply-To: <1331628428-24017-6-git-send-email-b29396@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> +			dma-apbh@80004000 {
> +				compatible = "fsl,mxs-dma-apbh";
> +				reg =<0x80004000 2000>;
> +			};
> +
Why you do not add the `interrupt` for the it?
the gpmi-nand needs to parse the interrupt out.

BR
Huang Shijie


