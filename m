Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2GaOZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:25:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:58322 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2GaOZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:25:40 -0400
Subject: Re: [PATCH v8 3/7] powerpc/85xx: implement hardware timebase sync
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788159-27529-4-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 31 Jul 2012 09:24:37 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A3F1406E-C3A0-4393-BA50-1299A5EC8545@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <1342788159-27529-4-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:42 AM, Zhao Chenhui wrote:

> Do hardware timebase sync. Firstly, stop all timebases, and transfer
> the timebase value of the boot core to the other core. Finally,
> start all timebases.
> 
> Only apply to dual-core chips, such as MPC8572, P2020, etc.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> arch/powerpc/include/asm/fsl_guts.h |    2 +
> arch/powerpc/platforms/85xx/smp.c   |   82 +++++++++++++++++++++++++++++++++++
> 2 files changed, 84 insertions(+), 0 deletions(-)

applied to next

- k