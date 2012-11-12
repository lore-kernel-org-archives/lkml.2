Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2KLMAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:00:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39776 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KLMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:00:45 -0500
MIME-Version: 1.0
In-Reply-To: <052ad319f1599baa9a2fc840726a98f573e08672.1352400580.git.josh.cartwright@ni.com>
References: <cover.1352400580.git.josh.cartwright@ni.com>
	<052ad319f1599baa9a2fc840726a98f573e08672.1352400580.git.josh.cartwright@ni.com>
Date: Mon, 12 Nov 2012 13:00:43 +0100
X-Google-Sender-Auth: onX2PyFkTL_t8TVjkknVfYI6Jgo
Message-ID: <CAHTX3dJN1RyuUnz3Ke7j2aiA1kvN5jLVvVEsjAc40tUjSMvTJA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ARM: zynq: dts: split up device tree
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: John Linn <john.linn@xilinx.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

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

We have had discussion about this dtsi stuff and also based on our
previous discussion
all trying to convince me that this solution is right solution.
I still have doubts but I will apply it to arm-next tree and we can
revisit it in future.

Thanks,
Michal
