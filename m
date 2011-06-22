Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1FVLlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:41:49 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:12748
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308Ab1FVLlr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:41:47 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH 2/7] powerpc: introduce ePAPR embedded hypervisor hcall interface
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1305813272-31826-3-git-send-email-timur@freescale.com>
Date: Wed, 22 Jun 2011 06:41:34 -0500
CC: <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <A51DF224-1AB1-43CA-8880-253D7FD837B5@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-3-git-send-email-timur@freescale.com>
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.1084)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19, 2011, at 8:54 AM, Timur Tabi wrote:

> ePAPR hypervisors provide operating system services via a "hypercall"
> interface.  The following steps need to be performed to make an hcall:
> 
> 1. Load r11 with the hcall number
> 2. Load specific other registers with parameters
> 3. Issue instrucion "sc 1"
> 4. The return code is in r3
> 5. Other returned parameters are in other registers.
> 
> To provide this service to the kernel, these steps are wrapped in inline
> assembly functions.  Standard ePAPR hcalls are in epapr_hcalls.h, and Freescale
> extensions are in fsl_hcalls.h.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> arch/powerpc/include/asm/epapr_hcalls.h |  502 +++++++++++++++++++++++
> arch/powerpc/include/asm/fsl_hcalls.h   |  655 +++++++++++++++++++++++++++++++
> 2 files changed, 1157 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/include/asm/epapr_hcalls.h
> create mode 100644 arch/powerpc/include/asm/fsl_hcalls.h

applied to next

- k
