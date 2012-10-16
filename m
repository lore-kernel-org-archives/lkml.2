Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2JPPOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:14:07 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:57435 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754151Ab2JPPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:14:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rPLqIopjUw4mvkCVGsGXv
Date: Tue, 16 Oct 2012 08:13:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux@arm.linux.org.uk, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] Revert "serial: omap: fix software flow control"
Message-ID: <20121016151357.GN15569@atomide.com>
References: <1350396562-32579-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350396562-32579-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [121016 07:16]:
> This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
> (serial: omap: fix software flow control).
> 
> As Russell has pointed out, that commit isn't fixing
> Software Flow Control at all, and it actually makes
> it even more broken.
> 
> It was agreed to revert this commit and use Russell's
> latest UART patches instead.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

This seems like the best way to go for the -rc series:

Acked-by: Tony Lindgren <tony@atomide.com>
