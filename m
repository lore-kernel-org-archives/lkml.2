Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2GaOZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:25:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:58315 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab2GaOZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:25:35 -0400
Subject: Re: [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788159-27529-3-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 31 Jul 2012 09:24:28 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <51671362-4E74-43F2-B9AF-F5C376F51038@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <1342788159-27529-3-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:42 AM, Zhao Chenhui wrote:

> In the case of cpu hotplug, the cpu_state should be set to CPU_UP_PREPARE when kicking cpu.
> Otherwise, the cpu_state is always CPU_DEAD after calling generic_set_cpu_dead(), which
> makes the delay in generic_cpu_die() not happen.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
> arch/powerpc/include/asm/smp.h |    1 +
> arch/powerpc/kernel/smp.c      |   12 +++++++++++-
> 2 files changed, 12 insertions(+), 1 deletions(-)

applied to next

- k