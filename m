Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2FZWK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:10:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:35114 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2FZWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:10:56 -0400
Message-ID: <1340748634.3732.27.camel@pasglop>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, scottwood@freescale.com,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 08:10:34 +1000
In-Reply-To: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 18:25 +0800, Zhao Chenhui wrote:
> Do hardware timebase sync. Firstly, stop all timebases, and transfer
> the timebase value of the boot core to the other core. Finally,
> start all timebases.
> 
> Only apply to dual-core chips, such as MPC8572, P2020, etc.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> Changes for v6:
>  * added 85xx_TB_SYNC
>  * added isync() after set_tb()
>  * removed extra entries from mpc85xx_smp_guts_ids

What's that CONFIG option for ?

Cheers,
Ben.


