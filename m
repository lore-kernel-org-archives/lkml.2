Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1GSX4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:56:49 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56315 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1GSX4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:56:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <20110719234158.2779.15394.stgit@ponder>
References: <20110719234158.2779.15394.stgit@ponder>
Date: Tue, 19 Jul 2011 16:56:46 -0700
Message-ID: <CAOesGMiy1t-98KZ_imFkGO-ify3S_00d_0XKc2vcLNRekxOvpw@mail.gmail.com>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, swarren@nvidia.com,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice!


On Tue, Jul 19, 2011 at 4:43 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Everything required to populate NVIDIA Tegra devices from the device
> tree.  This patch adds a new DT_MACHINE_DESC() which matches against
> a tegra20 device tree.  So far it only registers the on-chip devices,
> but it will be refined in follow on patches to configure clocks and
> pin IO from the device tree also.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Olof Johansson <olof@lixom.net


Minor nit:

> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -0,0 +1,148 @@
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +       model = "NVIDIA Tegra 250";

NVIDIA Tegra2 or Tegra20 to be more in line with the recent 250->20
conversion (and Harmony)
