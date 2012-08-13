Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2HMLkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:40:18 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:48158 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab2HMLkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:40:16 -0400
MIME-Version: 1.0
In-Reply-To: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
References: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Mon, 13 Aug 2012 17:09:54 +0530
Message-ID: <CAMQu2gwbG4XSBQvvbMJ8aKRy=LRG44dKv+feSo-mso_jju71oQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/4] Add device tree data for omap5
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav,

On Mon, Aug 13, 2012 at 3:35 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
>
> The following patch series add i2c support for omap5.
> As well as enable I2C based devices like pressure and temperature
> through device tree. Also add onchip keypad dts data.
>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> Sourav Poddar (4):
>   arm/dts: omap5-evm: Add I2C support
>   arm/dts: omap5-evm: Add tmp102 sensor support
>   arm/dts: omap5-evm: Add keypad data
>   arm/dts: omap5-evm: Add bmp085 sensor support
>
>  arch/arm/boot/dts/omap5-evm.dts |   30 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/omap5.dtsi    |   40
> +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+), 0 deletions(-)
>
The entire series looks fine to me.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
