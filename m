Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1FVLlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:41:40 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20492
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752552Ab1FVLli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:41:38 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH 1/7] powerpc: make irq_choose_cpu() available to all PIC drivers
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1305813272-31826-2-git-send-email-timur@freescale.com>
Date: Wed, 22 Jun 2011 06:41:26 -0500
CC: <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-ID: <9215F3F9-AA0A-4C76-B2F0-DF18A9FAAB35@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-2-git-send-email-timur@freescale.com>
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.1084)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19, 2011, at 8:54 AM, Timur Tabi wrote:

> From: Stuart Yoder <stuart.yoder@freescale.com>
> 
> Move irq_choose_cpu() into arch/powerpc/kernel/irq.c so that it can be used
> by other PIC drivers.  The function is not MPIC-specific.
> 
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> arch/powerpc/include/asm/irq.h |    2 ++
> arch/powerpc/kernel/irq.c      |   35 +++++++++++++++++++++++++++++++++++
> arch/powerpc/sysdev/mpic.c     |   36 ------------------------------------
> 3 files changed, 37 insertions(+), 36 deletions(-)

applied to next

- k

