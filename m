Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1GTS4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:56:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53836 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1GTS4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:56:08 -0400
Date: Wed, 20 Jul 2011 12:56:07 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Olof Johansson <olof@lixom.net>
Cc: Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, swarren@nvidia.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720185607.GJ4642@ponder.secretlab.ca>
References: <20110719234158.2779.15394.stgit@ponder>
 <CAOesGMiy1t-98KZ_imFkGO-ify3S_00d_0XKc2vcLNRekxOvpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMiy1t-98KZ_imFkGO-ify3S_00d_0XKc2vcLNRekxOvpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 04:56:46PM -0700, Olof Johansson wrote:
> Nice!
> 
> 
> On Tue, Jul 19, 2011 at 4:43 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > Everything required to populate NVIDIA Tegra devices from the device
> > tree.  This patch adds a new DT_MACHINE_DESC() which matches against
> > a tegra20 device tree.  So far it only registers the on-chip devices,
> > but it will be refined in follow on patches to configure clocks and
> > pin IO from the device tree also.
> >
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Acked-by: Olof Johansson <olof@lixom.net
> 
> 
> Minor nit:
> 
> > +++ b/arch/arm/boot/dts/tegra20.dtsi
> > @@ -0,0 +1,148 @@
> > +/include/ "skeleton.dtsi"
> > +
> > +/ {
> > +       model = "NVIDIA Tegra 250";
> 
> NVIDIA Tegra2 or Tegra20 to be more in line with the recent 250->20
> conversion (and Harmony)

I'll remove the model property entirely.  It doesn't make any sense
for the soc include file since "model" describes the system.

g.
