Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2CWSbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:31:04 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:18317 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab2CWSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:31:03 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LeDGtgHddgUZ394kpJ112
Date: Fri, 23 Mar 2012 11:30:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/9] omap: fix visibility of omap2_mbox_iva_priv
Message-ID: <20120323183057.GG9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
 <1332522836-29517-3-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-3-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:16]:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> map2_mbox_iva_priv is used on multiple omap2 socs but is hidden
> in an outdated #ifdef that is specific to a single soc.

I think this got fixed with 655850ed (ARM: OMAP2: fix mailbox init code).

Tony
