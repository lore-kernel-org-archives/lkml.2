Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2KHXyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:54:00 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:16270
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab2KHXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:53:59 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2012 18:53:59 EST
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zz4015Izz1de0h1202h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh906i1155h)
Date: Thu, 8 Nov 2012 15:38:45 -0800
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Michal Simek <michal.simek@xilinx.com>, John Linn <john.linn@xilinx.com>,
        <arm@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 0/5] zynq clk support
References: <cover.1352400580.git.josh.cartwright@ni.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cover.1352400580.git.josh.cartwright@ni.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d3a47d59-f146-464d-8a65-dc50a8f4d8c9@CO9EHSMHS028.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

did you also have a look at what is available in the Xilinx git repository?
There are also quite some patches to support common clock and port drivers over
to using it.
It would be great if we could combine our efforts instead of ending up with
competing solutions.

Thanks,
Soren


