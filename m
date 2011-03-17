Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1CQVMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:12:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37902 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1CQVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:12:29 -0400
Date: Thu, 17 Mar 2011 22:12:26 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: [PATCHv3 2/3] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Message-ID: <20110317211226.GC31219@pengutronix.de>
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
 <20110317081832.GS29521@pengutronix.de>
 <56132A77AB93C141BF06E6B96CA6CFEA1B7F51@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56132A77AB93C141BF06E6B96CA6CFEA1B7F51@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Thu, Mar 17, 2011 at 04:52:44PM +0000, Nguyen Dinh-R00091 wrote:
> Yes, I have and its build fine for mx3_defconfig. I did find a build issue with mx27_defconfig, but it's not related to this patch:
> 
> In file included from arch/arm/mm/init.c:27:
> /arm/include/asm/tlb.h: In function 'tlb_flush_mmu':
> arch/arm/include/asm/tlb.h:104: error: implicit declaration of function 'release_pages'
> arch/arm/include/asm/tlb.h: In function 'tlb_remove_page':
> arch/arm/include/asm/tlb.h:168: error: implicit declaration of function 'page_cache_release'
> make[1]: *** [arch/arm/mm/init.o] Error 1
> make: *** [arch/arm/mm] Error 2
This is already fixed in Russell's tree, and I guess in Linus', too.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
