Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab1FVLmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:42:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20928
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757586Ab1FVLmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:42:02 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz9371M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Subject: Re: [PATCH 4/7] powerpc: add Freescale hypervisor partition control functions
MIME-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1305813272-31826-5-git-send-email-timur@freescale.com>
Date: Wed, 22 Jun 2011 06:41:52 -0500
CC: <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-ID: <CC6FDFDC-FB47-495E-B998-5D1CD115AA2D@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-5-git-send-email-timur@freescale.com>
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.1084)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19, 2011, at 8:54 AM, Timur Tabi wrote:

> Add functions to restart and halt the current partition when running under
> the Freescale hypervisor.  These functions should be assigned to various
> function pointers of the ppc_md structure during the .probe() function for
> the board:
> 
> 	ppc_md.restart = fsl_hv_restart;
> 	ppc_md.power_off = fsl_hv_halt;
> 	ppc_md.halt = fsl_hv_halt;
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> arch/powerpc/sysdev/fsl_soc.c |   27 +++++++++++++++++++++++++++
> arch/powerpc/sysdev/fsl_soc.h |    3 +++
> 2 files changed, 30 insertions(+), 0 deletions(-)

applied to next

- k

