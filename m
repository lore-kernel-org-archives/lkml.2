Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2KELcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:32:22 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59298 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2KELcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:32:19 -0500
MIME-Version: 1.0
In-Reply-To: <1dc81a3260da0a911dbcabd737547b7bff16a99c.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<1dc81a3260da0a911dbcabd737547b7bff16a99c.1351721190.git.josh.cartwright@ni.com>
Date: Mon, 5 Nov 2012 12:32:17 +0100
X-Google-Sender-Auth: M5KJSN3G-wPnCLAAq32QB13s7ig
Message-ID: <CAHTX3dJKT=zZ5wYV-iB=XVba0ah7O18C9s8fo1M9WPs1NfeK-g@mail.gmail.com>
Subject: Re: [PATCH 4/8] ARM: zynq: dts: split up device tree
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
> The purpose of the created zynq-7000.dtsi file is to describe the
> hardware common to all Zynq 7000-based boards.  Also, get rid of the
> zynq-ep107 device tree, since it is not hardware anyone can purchase.
>
> Add a zc702 dts file based on the zynq-7000.dtsi.  Add it to the
> dts/Makefile so it is built with the 'dtbs' target.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/boot/dts/Makefile                         |  1 +
>  .../boot/dts/{zynq-ep107.dts => zynq-7000.dtsi}    | 19 +++-----------
>  arch/arm/boot/dts/zynq-zc702.dts                   | 30 ++++++++++++++++++++++
>  arch/arm/mach-zynq/common.c                        |  3 ++-
>  4 files changed, 36 insertions(+), 17 deletions(-)
>  rename arch/arm/boot/dts/{zynq-ep107.dts => zynq-7000.dtsi} (79%)
>  create mode 100644 arch/arm/boot/dts/zynq-zc702.dts

Not going to apply this. We need to finish our discussion in
"[PATCH v4 1/5] zynq: use GIC device tree bindings" before.

Definitely I like idea to use "xlnx,zynq-7000" generic model name.

Thanks,
Michal
