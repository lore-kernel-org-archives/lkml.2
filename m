Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1BDUKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:10:49 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35405 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1BDUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:10:47 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19m6xZDOIYb1AhdZrq8S8dh
Date: Fri, 4 Feb 2011 12:10:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/20] mach-omap2: smartreflex: world-writable debugfs
 voltage files
Message-ID: <20110204201023.GD3322@atomide.com>
References: <cover.1296818921.git.segoon@openwall.com>
 <96a2b24548af3a68fde712c68b49e856e53ea1fc.1296818921.git.segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96a2b24548af3a68fde712c68b49e856e53ea1fc.1296818921.git.segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vasiliy Kulikov <segoon@openwall.com> [110204 04:22]:
> Don't allow everybody to change voltage settings.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile the driver, so it is not tested at all.

And this one.

Tony
