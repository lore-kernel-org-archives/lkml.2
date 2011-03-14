Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1CNSMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:12:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20391 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab1CNSMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:12:17 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OYqfKJABn1ZUWJJBHjvsB
Date: Mon, 14 Mar 2011 11:12:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andy Green <andy.green@linaro.org>, patches@linaro.org
Subject: Re: [RFC PATCH 3/5] OMAP2+:Common CPU DIE ID reading code reads
 wrong registers for OMAP4430
Message-ID: <20110314181207.GD7258@atomide.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
 <20110312225054.27728.89155.stgit@otae.warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312225054.27728.89155.stgit@otae.warmcat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andy Green <andy@warmcat.com> [110312 14:49]:
> This adapts the register offsets used to read the CPU DIE ID registers
> when run on 44XX so they match what is in the OMAP4430 Reference Manual
> page 269

I'll apply only this patch, looks like the rest needs more discussion.

Regards,

Tony
