Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1GWD42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 23:56:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GWD40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 23:56:26 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	<CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	<CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
	<CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
Date: Sat, 23 Jul 2011 09:26:25 +0530
Message-ID: <CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com, rmk+kernel@arm.linux.org.uk,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2011 03:53, Williams, Dan J <dan.j.williams@intel.com> wrote:

>
> Unless you guaranteed that every id is globally unique I don't see how
> they are generically usable by common clients?
>
Yes. And the first step is to allow DMAC drivers to freely set chan_id value.
Platform could pass the list and mapping of supported 'global channels'
via platform_data(?) which the DMAC drivers could set in chan_id
And I am not sure of defining a new variable for that, because chan_id
is actually used only by some dmac drivers for internal purpose only -
which they could do by private variables.

Proposal to have global cross-platform enum of channel-IDs defined by
client drivers, was to be my next patch.
Though I think, this patch is valid in it's own light.

-j

-- 
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  -
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
