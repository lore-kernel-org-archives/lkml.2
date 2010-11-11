Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0KKMUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:20:15 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:55547
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276Ab0KKMUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:20:13 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bhz2dh2a8h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Subject: Re: [PATCH 2/4][v2] fsl_rio: fix non-standard HID1 register access
MIME-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1288776997-23562-1-git-send-email-b21989@freescale.com>
Date: Thu, 11 Nov 2010 06:20:02 -0600
CC: <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Content-Transfer-Encoding: 7bit
Message-ID: <BD0B9175-F78C-49FB-8938-697ECA659B82@freescale.com>
References: <1288776997-23562-1-git-send-email-b21989@freescale.com>
To: Shaohui Xie <b21989@freescale.com>
X-Mailer: Apple Mail (2.1081)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 3, 2010, at 4:36 AM, Shaohui Xie wrote:

> Signed-off-by: Shaohui Xie <b21989@freescale.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Kumar Gala <kumar.gala@freescale.com>
> Cc: Roy Zang <tie-fei.zang@freescale.com>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> ---
> arch/powerpc/kernel/cpu_setup_fsl_booke.S |    6 ++++++
> arch/powerpc/sysdev/fsl_rio.c             |    2 --
> 2 files changed, 6 insertions(+), 2 deletions(-)

applied to next

- k

