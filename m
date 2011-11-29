Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1K2Gq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:46:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11740 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1K2Gqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:46:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 28 Nov 2011 22:46:32 -0800
Date: Tue, 29 Nov 2011 08:46:30 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Message-ID: <20111129064630.GW19069@tbergstrom-lnx.Nvidia.com>
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 06:00:44PM +0100, Peter De Schrijver wrote:
> This patchset converts ARCH_NR_GPIO to a Kconfig variable as suggested by
> Russel King. It also converts some platforms to the new model.
> 
> Peter De Schrijver (3):
>   ARM: ARCH_NR_GPIO: Make ARCH_NR_GPIO a Kconfig variable
>   ARM: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
>   ARM: mach-ux500 Use CONFIG_ARCH_NR_GPIO

Ping? What should we do with this?

Cheers,

Peter.
