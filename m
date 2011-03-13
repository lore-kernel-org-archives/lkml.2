Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1CMXkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 19:40:52 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:33055 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab1CMXku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 19:40:50 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V12 3/4] ptp: Added a clock driver for the IXP46x.
References: <cover.1298878618.git.richard.cochran@omicron.at>
	<cd6ddff0dcca60ac88b35660505d7bf54ad32405.1298878618.git.richard.cochran@omicron.at>
Date: Mon, 14 Mar 2011 00:40:48 +0100
In-Reply-To: <cd6ddff0dcca60ac88b35660505d7bf54ad32405.1298878618.git.richard.cochran@omicron.at>
	(Richard Cochran's message of "Mon, 28 Feb 2011 08:58:27 +0100")
Message-ID: <m3ei6azj0f.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> This patch adds a driver for the hardware time stamping unit found on the
> IXP465. The basic clock operations and an external trigger are implemented.
>
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Acked-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h |   78 ++++++
>  drivers/net/arm/ixp4xx_eth.c                  |  192 ++++++++++++++-
>  drivers/ptp/Kconfig                           |   13 +
>  drivers/ptp/Makefile                          |    1 +
>  drivers/ptp/ptp_ixp46x.c                      |  332 +++++++++++++++++++++++++

I can't see any obvious problem in this code, though I don't have IXP46x
hardware.

Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
-- 
Krzysztof Halasa
