Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2AFND7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 08:03:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46738 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab2AFND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 08:03:57 -0500
Date: Fri, 6 Jan 2012 21:14:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120106131411.GA6372@S2101-09.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:33:54AM +0000, Dong Aisheng-B29396 wrote:
> In board dts file:
> usdhc@0219c000 { /* uSDHC4 */
>         fsl,card-wired;
>         status = "okay";
>         pinmux = <&pinctrl_sd4>;

Would it be more proper to have the phandle named as 'pinctrl' than
'pinmux'?

> };

-- 
Regards,
Shawn
