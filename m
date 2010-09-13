Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0IMLom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:44:42 -0400
Received: from 31.mail-out.ovh.net ([213.186.62.10]:44482 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755085Ab0IMLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:44:41 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 07:44:41 EDT
Date: Mon, 13 Sep 2010 13:37:00 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Maxim Osipov <maxim.osipov@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] AT91: Add flexibity board support
Message-ID: <20100913113700.GA2138@game.jcrosoft.org>
References: <4C8DFA84.4040501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8DFA84.4040501@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 942941173580147682
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:18 Mon 13 Sep     , Maxim Osipov wrote:
> Hello,
> 
> This patch adds support for AT91 Flexibity board.
> 
> Kind regards,
> Maxim
> 
> >From ccb19f0d6dbda5356e64c1ce5d0fe1396c548f1a Mon Sep 17 00:00:00 2001
> From: Maxim Osipov <maxim.osipov@gmail.com>
> Date: Sun, 12 Sep 2010 16:23:48 +0400
> Subject: [PATCH v2] AT91: Add flexibity board support
> 
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
> ---
>  arch/arm/mach-at91/Kconfig           |    6 ++
>  arch/arm/mach-at91/Makefile          |    1 +
>  arch/arm/mach-at91/board-flexibity.c |  166 ++++++++++++++++++++++++++++++++++
>  3 files changed, 173 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-at91/board-flexibity.c
> 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
