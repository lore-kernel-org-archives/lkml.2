Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2FZODw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:03:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:55884 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab2FZODu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:03:50 -0400
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 26 Jun 2012 09:03:42 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AB6D43A9-FC54-40D2-A9B0-8B2E785124F9@kernel.crashing.org>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 26, 2012, at 5:25 AM, Zhao Chenhui wrote:

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
> * added 85xx_TB_SYNC
> * added isync() after set_tb()
> * removed extra entries from mpc85xx_smp_guts_ids

Why only on dual-core chips?  Is this because of something related to 2 cores, or related to corenet vs non-corenet SoCs and how turning on/off the timebase works in the SOC?

- k