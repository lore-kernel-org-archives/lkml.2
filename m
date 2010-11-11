Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0KKMUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:20:10 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19316
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756201Ab0KKMUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:20:09 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Subject: Re: [PATCH 1/4][v2] powerpc: add e500 HID1 bit definition
MIME-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1288776931-20689-1-git-send-email-b21989@freescale.com>
Date: Thu, 11 Nov 2010 06:20:00 -0600
CC: <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Content-Transfer-Encoding: 7bit
Message-ID: <8215A0B4-135B-47B1-9D01-D0E5DD3243BD@freescale.com>
References: <1288776931-20689-1-git-send-email-b21989@freescale.com>
To: Shaohui Xie <b21989@freescale.com>
X-Mailer: Apple Mail (2.1081)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 3, 2010, at 4:35 AM, Shaohui Xie wrote:

> From: Li Yang <leoli@freescale.com>
> 
> Also make 74xx HID1 definition conditional.
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Shaohui Xie <b21989@freescale.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Kumar Gala <kumar.gala@freescale.com>
> Cc: Roy Zang <tie-fei.zang@freescale.com>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> ---
> These patches have been send for almost one week, and has no feedback.
> 
> arch/powerpc/include/asm/reg.h       |    2 ++
> arch/powerpc/include/asm/reg_booke.h |   14 ++++++++++++++
> 2 files changed, 16 insertions(+), 0 deletions(-)

applied to next

- k

