Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2CWRWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:22:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60125 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2CWRWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:22:20 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/0slbOdOZu+FM02K57WOD+
Date: Fri, 23 Mar 2012 10:22:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 4/9] ARM: omap2+: fix building without i2c
Message-ID: <20120323172216.GB9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
 <1332522836-29517-5-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-5-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:16]:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A trivial typo causes build breakage when I2C is disabled
> and omap_i2c_reset is set to NULL on OMAP:
> 
> omap_hwmod_44xx_data.c:2287:11: error: lvalue required as unary '&' operand
> 
> Removing the '&' character solves this.

We are now building in the omap_i2c_reset always, so this
should be revalidated. We currently don't have NULL version
of omap_i2c_reset any longer, so those '&' for functions are
mostly cosmetic right now.

Anyways, at least the commit message should be changed to
be current.

Regards,

Tony
