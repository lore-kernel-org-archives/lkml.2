Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1KTPxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 10:53:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:36740 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1KTPxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 10:53:35 -0500
Subject: Re: [PATCH] powerpc/p3060qds: Fix select of 'MPC8xxx_GPIO'
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1321141830.20271.22.camel@x61.thuisdomein>
Date: Sun, 20 Nov 2011 09:53:16 -0600
Cc: Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Anatolij Gustschin <agust@denx.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8FD955D3-D7DE-45DF-B9F5-247209532B4B@kernel.crashing.org>
References: <1321141830.20271.22.camel@x61.thuisdomein>
To: Paul Bolle <pebolle@tiscali.nl>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 12, 2011, at 5:50 PM, Paul Bolle wrote:

> The driver for the Freescale P3060 QDS got added by commit 96cc017c5b
> ("[...] Add support for P3060QDS board"). Its Kconfig entry selects
> MPC8xxx_GPIO. But at the time that driver got added MPC8xxx_GPIO was
> already renamed to GPIO_MPC8XXX, by commit c68308dd50c ("gpio: move
> mpc8xxx/512x gpio driver to drivers/gpio").
> 
> So make this driver select GPIO_MPC8XXX.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Bravely untested: I haven't got the hardware nor the PPC toolchain
> needed to build this. And it seems this needs (build) testing anyhow.
> 
> 1) Sent to the people who wrote the two patches mentioned in the commit
> explanation and CC'd the non-authors who signed-off these patches.
> 
> 2) The config tools do not complain about selects that cannot be met
> because they concern a Kconfig symbol that doesn't even exist. Shouldn't
> they be made to complain in that case?
> 
> arch/powerpc/platforms/85xx/Kconfig |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

applied to merge

- k
