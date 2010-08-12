Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab0HLBWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:22:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:60656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0HLBWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:22:03 -0400
Subject: Re: [PATCH] ARM: Fix gen_nand probe structures contents
From: David Woodhouse <dwmw2@infradead.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "kernel@wantstofly.org" <kernel@wantstofly.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "khc@pm.waw.pl" <khc@pm.waw.pl>, "tj@kernel.org" <tj@kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
In-Reply-To: <1281575694-17551-1-git-send-email-marek.vasut@gmail.com>
References: <1281575694-17551-1-git-send-email-marek.vasut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 02:21:52 +0100
Message-ID: <1281576112.12475.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 02:14 +0100, Marek Vasut wrote:
> These three platforms didn't properly fill nr_chips in gen_nand
> registration and
> therefore depended on gen_nand bug fixed by the following patch:
> 
> "mtd: gen_nand: fix support for multiple chips"
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com> 

Thanks. I've applied that to the mtd-2.6.git tree, which has a few
straggling commits I'll be asking Linus to pull shortly.

In case there are any more, would you care to complement it with a check
in the driver that detects the nonsensical case of nr_chips == 0,
assumes it means 1, and also warns about it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

