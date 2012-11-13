Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab2KMEym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 23:54:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37510 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2KMEyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 23:54:41 -0500
Message-ID: <50A1D290.3050409@wwwdotorg.org>
Date: Mon, 12 Nov 2012 21:54:40 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [RFC] MIPS: BCM63XX: add simple Device Tree includes for all
 SoCs
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-3-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-3-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Add simple Device Tree include files for all currently supported SoCs.
> These will be populated with device definitions as driver support
> gets added.

>  arch/mips/bcm63xx/dts/bcm6328.dtsi |   30 ++++++++++++++++++++++++++++++
>  arch/mips/bcm63xx/dts/bcm6338.dtsi |   30 ++++++++++++++++++++++++++++++
>  arch/mips/bcm63xx/dts/bcm6345.dtsi |   30 ++++++++++++++++++++++++++++++
>  arch/mips/bcm63xx/dts/bcm6348.dtsi |   30 ++++++++++++++++++++++++++++++
>  arch/mips/bcm63xx/dts/bcm6358.dtsi |   33 +++++++++++++++++++++++++++++++++
>  arch/mips/bcm63xx/dts/bcm6368.dtsi |   33 +++++++++++++++++++++++++++++++++

All of ARM, c6x, microblaze, openrisc, powerpc put device tree files
into arch/${arch}/boot/dts/ - should MIPS follow the same layout?
