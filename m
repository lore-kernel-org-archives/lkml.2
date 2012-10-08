Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2JHVUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:20:18 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:30972 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755073Ab2JHVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:20:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ABbvJ/+xan+Oynt0qrDMe
Date: Mon, 8 Oct 2012 14:20:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: khilman@ti.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/arm/plat-omap/omap-pm-noop.c: Remove unecessary
 semicolon
Message-ID: <20121008212009.GM13011@atomide.com>
References: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
 <1347986174-30287-6-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347986174-30287-6-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Senna Tschudin <peter.senna@gmail.com> [120918 09:37]:
> Found by http://coccinelle.lip6.fr/
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  arch/arm/plat-omap/omap-pm-noop.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Thanks applying into omap fixes branch.

Regards,

Tony
