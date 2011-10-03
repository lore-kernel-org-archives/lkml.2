Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1JCFOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:14:39 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:33650 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750883Ab1JCFOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:14:33 -0400
Message-ID: <4E8944B2.4020700@ti.com>
Date: Mon, 03 Oct 2011 10:44:26 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/30] ARM: omap2: irq.c is always needed
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-15-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-15-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> The Makefile only includes irq.o for omap2 and omap3, but it's in
> fact also required to build omap4-only kernels.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
That should not be the case. Why do you think it is needed for OMAP4 ?
There is nothing in this file which OMAP4 needs since it makes
use of GIC and wakeupgen for it's interrupt handling.


Regards
Santosh
