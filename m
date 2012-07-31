Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2GaOZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:25:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:58326 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab2GaOZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:25:45 -0400
Subject: Re: [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788159-27529-5-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 31 Jul 2012 09:24:46 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6D7449F5-A4C4-4E3F-AD47-CC103B9044ED@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <1342788159-27529-5-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:42 AM, Zhao Chenhui wrote:

> Add support to disable and re-enable individual cores at runtime
> on MPC85xx/QorIQ SMP machines. Currently support e500v1/e500v2 core.
> 
> MPC85xx machines use ePAPR spin-table in boot page for CPU kick-off.
> This patch uses the boot page from bootloader to boot core at runtime.
> It supports 32-bit and 36-bit physical address.
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jin Qing <b24347@freescale.com>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
> arch/powerpc/Kconfig                  |    6 ++-
> arch/powerpc/include/asm/cacheflush.h |    2 +
> arch/powerpc/include/asm/smp.h        |    1 +
> arch/powerpc/kernel/head_fsl_booke.S  |   28 ++++++++++
> arch/powerpc/platforms/85xx/smp.c     |   90 ++++++++++++++++++++++++++++-----
> 5 files changed, 112 insertions(+), 15 deletions(-)

applied to next

- k