Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2CNGB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:01:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33793 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab2CNGBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:01:55 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Date: Wed, 14 Mar 2012 06:56:23 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        vinod.koul@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, rdunlap@xenotime.net, shawn.guo@freescale.com,
        kernel@pengutronix.de, cjb@laptop.org,
        Dong Aisheng <b29396@freescale.com>, s.hauer@pengutronix.de
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <20120313172351.97C5E3E053B@localhost> <20120314054116.GD21337@S2101-09.ap.freescale.net>
In-Reply-To: <20120314054116.GD21337@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203140656.24301.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Shawn Guo,

> On Tue, Mar 13, 2012 at 11:23:51AM -0600, Grant Likely wrote:
> ...
> 
> > > +	apb@80000000 {
> > > +		compatible = "simple-bus";
> > > +		#address-cells = <1>;
> > > +		#size-cells = <1>;
> > > +		reg = <0x80000000 0x80000>;
> > > +		ranges;
> > > +
> > > +		apbh@80000000 {
> > > +			compatible = "simple-bus";
> > > +			#address-cells = <1>;
> > > +			#size-cells = <1>;
> > > +			reg = <0x80000000 0x3c900>;
> > > +			ranges;
> > > +
> > > +			icoll: interrupt-controller@80000000 {
> > > +				compatible = "fsl,imx28-icoll";
> > > +				interrupt-controller;
> > > +				#interrupt-cells = <1>;
> > > +				reg = <0x80000000 0x2000>;
> > > +			};
> > > +		};
> > > +
> > > +		apbx@80040000 {
> > > +			compatible = "simple-bus";
> > > +			#address-cells = <1>;
> > > +			#size-cells = <1>;
> > > +			reg = <0x80040000 0x40000>;
> > > +			ranges;
> > > +
> > > +			uart1: uart@80074000 {
> > > +				compatible = "arm,pl011", "arm,primecell";
> > > +				reg = <0x80074000 0x2000>;
> > > +				interrupts = <47>;
> > > +			};
> > > +		};
> > 
> > What is the purpose of the apbh and apbx busses?  Will more device nodes
> > get added to them later, or does each only contain a single device?
> 
> Since our ultimate goal is to convert mach-mxs over to device tree,
> I would also suggest we have all the hardware blocks defined in dts
> from the beginning.

Agreed.

Best regards,
Marek Vasut
