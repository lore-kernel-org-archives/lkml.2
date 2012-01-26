Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2AZX70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:59:26 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:40552 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2AZX7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:59:25 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19UmQIJuZ+bI7aalGLc8r6b
Date: Thu, 26 Jan 2012 15:59:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] arch/arm/mach-omap2/devices.c: introduce missing
 kfree
Message-ID: <20120126235922.GE29812@atomide.com>
References: <1324661974-17281-6-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324661974-17281-6-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Julia Lawall <julia@diku.dk> [111223 09:07]:
> pdata needs to be freed before leaving the function in an error case.

Thanks applying into fixes.

Tony
