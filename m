Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1LGRIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:08:36 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5584 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1LGRId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:08:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Dec 2011 09:08:27 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Chew <AChew@nvidia.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 7 Dec 2011 09:08:26 -0800
Subject: RE: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Thread-Index: Acy0ksKRlFZ1L/wmTAmiGfgitaRUbwAb+Fzw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77736@HQMAIL01.nvidia.com>
References: <1311283067-18952-1-git-send-email-achew@nvidia.com>
 <20111207034200.GG32515@game.jcrosoft.org>
In-Reply-To: <20111207034200.GG32515@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Christophe PLAGNIOL-VILLARD wrote at Tuesday, December 06, 2011 8:42 PM:
> On 14:17 Thu 21 Jul     , achew@nvidia.com wrote:
> > From: Andrew Chew <achew@nvidia.com>
> >
> > Add code to try to get platform data information (register base, irq,
> > modes, various tuning parameters) from device tree, if not present in board
> > files.
...
> > +static u64 tegra_ehci_dmamask = DMA_BIT_MASK(TEGRA_USB_DMA_ALIGN);
> I really does not like this
> as the dmamask is supposed to be device specific
> 
> before we put it in the soc codewhich alow to have it generic
> 
> this need to be manage a DT level
> 	dmamask = <32>
> 
> or
> 	dmamask = <0xffffffff>

Jean-Christophe,

The patch you're replying to is very old; Olof has posted (and applied)
some basic USB bindings much more recently than the above.

-- 
nvpublic

