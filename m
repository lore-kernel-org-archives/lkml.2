Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1HRJQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:16:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1HRJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:16:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Date: Thu, 18 Aug 2011 11:15:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com> <201108171323.38441.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF04AF6F3062@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AF6F3062@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108181115.53101.arnd@arndb.de>
X-Provags-ID: V02:K0:NQyDB5FY3AstIXSEhnzlrJqTy4AL7DyGS3E5P7RquUP
 7rQc6AaeaC4JUHumBGz9bTmnnBNhp8iOE+GfrxFnzNLXiJYND6
 SROPlJ+gCPcL60eV452kthmy2VF+cLhMKewcpOxYcpWQcyoOHs
 sq+2hdEoAoDMkx+Q6kzyLqql0SFU0qQDAvVXd4onRuwLQrEAOY
 DETjgWt9Jxqh3B9yPYn6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 August 2011, Stephen Warren wrote:
> It looks like DT already supports the generic case for GPIO; each GPIO
> reference is of the form:
> 
> <&gpio 69 0>
> 
> and so each GPIO has a "parent" specified, and hence can come from a
> different controller.
> 
> For drivers, this is all completely hidden by of_get_gpio().
> 
> I imagine we'd just use the same pattern for pinmux. This would both
> support the general case, and end up being consistent with how GPIOs
> already work, so this seems like a win both ways.
> 

Ah right. I had not seen the gpio binding yet, so that definitely works.

	Arnd
