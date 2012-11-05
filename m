Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2KELff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:35:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38973 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2KELfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:35:31 -0500
MIME-Version: 1.0
In-Reply-To: <8c2fac7167cd7c5201d5e1d8e1ceeb183ee2f63f.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<8c2fac7167cd7c5201d5e1d8e1ceeb183ee2f63f.1351721190.git.josh.cartwright@ni.com>
Date: Mon, 5 Nov 2012 12:35:30 +0100
X-Google-Sender-Auth: sI7eRURc4t_KVa8xBZ6OWNq2Q9Q
Message-ID: <CAHTX3d+WePMm16xK0Mub9EZMSX9vg_FTFQG-u0vxXXxuv9j4Vg@mail.gmail.com>
Subject: Re: [PATCH 3/8] ARM: zynq: dts: add description of the second uart
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 Josh Cartwright <josh.cartwright@ni.com>:
> The zynq-7000 has an additional UART at 0xE0001000.  Describe it in the
> device tree.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/boot/dts/zynq-ep107.dts | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied to my testing branch.

Thanks,
Michal
