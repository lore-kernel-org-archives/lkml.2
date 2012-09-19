Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2ISOwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:52:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:56042 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2ISOwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:52:37 -0400
Subject: Re: [PATCH] powerpc/smp: Do not disable IPI interrupts during suspend
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
Date: Wed, 19 Sep 2012 09:52:16 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F9547F9E-3AF6-43EE-A6AA-A152E1E70D23@kernel.crashing.org>
References: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:47 AM, Zhao Chenhui wrote:

> During suspend, all interrupts including IPI will be disabled. In this case,
> the suspend process will hang in SMP. To prevent this, pass the flag
> IRQF_NO_SUSPEND when requesting IPI irq.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> arch/powerpc/kernel/smp.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

applied to next

- k