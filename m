Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2HNTgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:36:23 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:23213 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2HNTgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:36:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 173.50.127.139
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+j0yYgBtbxVREsmDWINmkMTkIzSLQlxHo=
Date: Tue, 14 Aug 2012 15:36:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: kirkwood: DT descriptor for Seagate FreeAgent
 Dockstar
Message-ID: <20120814193613.GS22226@titan.lakedaemon.net>
References: <1344177973-6505-1-git-send-email-sebastian.hesselbarth@googlemail.com>
 <1344177973-6505-2-git-send-email-sebastian.hesselbarth@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344177973-6505-2-git-send-email-sebastian.hesselbarth@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 04:46:13PM +0200, Sebastian Hesselbarth wrote:
> This adds the corresponding device tree descriptor for the
> Seagate FreeAgent Dockstar based on Kirkwood DT.
> 
> Please note that this patch requires the mach-kirkwood Makefile.boot typo
> fix to fully apply.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
...
> diff --git a/arch/arm/mach-kirkwood/Makefile.boot b/arch/arm/mach-kirkwood/Makefile.boot
> index a571755..2c2edfb 100644
> --- a/arch/arm/mach-kirkwood/Makefile.boot
> +++ b/arch/arm/mach-kirkwood/Makefile.boot
> @@ -11,3 +11,4 @@ dtb-$(CONFIG_MACH_TS219_DT)	+= kirkwood-qnap-ts219.dtb

This series looks great, but will go in after the above line is fixed.
Can you correct and resubmit so we don't get a conflict down the road?

You can just do a v2 of this patch in-reply-to this one.

thx,

Jason.
