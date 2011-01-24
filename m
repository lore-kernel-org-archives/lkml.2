Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1AXWqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:46:12 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40634 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AXWqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:46:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71602051"
Subject: Re: [PATCH v2 06/11] msm: irqs-8960: Interrupt map for MSM8960
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295468747-22796-7-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-7-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 14:45:42 -0800
Message-ID: <1295909142.29639.63.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
> +#define INT_VGIC                               (GIC_PPI_START + 0)
> +#define INT_DEBUG_TIMER_EXP                    (GIC_PPI_START + 1)
> +#define INT_GP_TIMER_EXP                       (GIC_PPI_START + 2)
> +#define INT_GP_TIMER2_EXP                      (GIC_PPI_START + 3)
> +#define WDT0_ACCSCSSNBARK_INT                  (GIC_PPI_START + 4)
> +#define WDT1_ACCSCSSNBARK_INT                  (GIC_PPI_START + 5)
> +#define AVS_SVICINT                            (GIC_PPI_START + 6)
> +#define AVS_SVICINTSWDONE                      (GIC_PPI_START + 7)
> +#define CPU_DBGCPUXCOMMRXFULL                  (GIC_PPI_START + 8)
> +#define CPU_DBGCPUXCOMMTXEMPTY                 (GIC_PPI_START + 9)
> +#define CPU_SICCPUXPERFMONIRPTREQ              (GIC_PPI_START + 10)
> +#define SC_AVSCPUXDOWN                         (GIC_PPI_START + 11)
> +#define SC_AVSCPUXUP                           (GIC_PPI_START + 12)
> +#define SC_SICCPUXACGIRPTREQ                   (GIC_PPI_START + 13)
> +#define SC_SICCPUXEXTFAULTIRPTREQ              (GIC_PPI_START + 14)
> +/* PPI 15 is unused */ 

How are you handling this at runtime?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

