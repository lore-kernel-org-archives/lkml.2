Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505Ab2BNTrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:47:25 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56184 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab2BNTrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:47:24 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Be5kH8J05Jpg2bnIsoUQT
Date: Tue, 14 Feb 2012 11:47:21 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH] arm: omap: usb-host: fix compile warning
Message-ID: <20120214194721.GR1426@atomide.com>
References: <1329209686-25551-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329209686-25551-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [120214 00:23]:
> when commit 3528c58 (OMAP: omap_device: when
> building return platform_device instead of
> omap_device) started returning a platform_device
> instead of a omap_device pointer when building
> a device, it failed to convert all users introducing
> a compile warning when building
> arch/arm/mach-omap2/usb-host.c.
> 
> This patch fixes that warning.

Thanks applying into fixes.

Tony
