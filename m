Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2KLWrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:47:10 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56064 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752198Ab2KLWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:47:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3zc+4rnEiU23akmJIsVYr
Date: Mon, 12 Nov 2012 14:47:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH v3 1/6] watchdog: omap_wdt: convert to new
 watchdog core
Message-ID: <20121112224703.GT6801@atomide.com>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
 <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Aaro Koskinen <aaro.koskinen@iki.fi> [121112 10:49]:
> Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
> multiple watchdogs. Since the new watchdog core supports multiple
> watchdogs, all watchdog drivers used on OMAP should be converted.
> 
> The legacy watchdog device node is still created, so this should not
> break existing users.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Tested-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
> Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

Wim, looks like these will cause merge conflicts with what we
have already queued in omap-for-v3.8/cleanup-prcm as patch
"watchdog: OMAP: use standard GETBOOTSTATUS interface; use
platform_data fn ptr" along with other ARM multiplatform
related clean up. If these look ackable to you, I can queue
these that's OK to you.

Regards,

Tony
