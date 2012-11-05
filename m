Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2KEMQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:16:10 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62273 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2KEMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <61e872b2cd4abc25c2dab82668e5094b590571a0.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
	<61e872b2cd4abc25c2dab82668e5094b590571a0.1351721190.git.josh.cartwright@ni.com>
Date: Mon, 5 Nov 2012 13:16:05 +0100
X-Google-Sender-Auth: h_byDDACwXPY6cX8IdwF92QSEtM
Message-ID: <CAHTX3dKSn0JwHsgCfLrgitb41OakHmw1o=uDRkshYi88fp2h1w@mail.gmail.com>
Subject: Re: [PATCH 6/8] serial: xilinx_uartps: kill CONFIG_OF conditional
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30 Josh Cartwright <josh.cartwright@ni.com>:
> The Zynq platform requires the use of CONFIG_OF.  Remove the #ifdef
> conditionals in the uartps driver.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  drivers/tty/serial/xilinx_uartps.c | 9 ---------
>  1 file changed, 9 deletions(-)

Please send this separately out of this patchset.
Also if you do this change which is understandable, you should also
add
depends on OF

Thanks,
Michal
