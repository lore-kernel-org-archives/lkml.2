Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2GaOZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:25:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:58297 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2GaOZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:25:10 -0400
Subject: Re: [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788159-27529-2-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 31 Jul 2012 09:24:16 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4C0232AB-6B1D-4D35-9400-941F3BE9AFC2@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <1342788159-27529-2-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:42 AM, Zhao Chenhui wrote:

> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
> arch/powerpc/platforms/85xx/smp.c |   46 ++++++++++++++++++------------------
> 1 files changed, 23 insertions(+), 23 deletions(-)

applied to next

- k