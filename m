Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2FZLZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:25:29 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59061 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2FZLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:25:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+VvqPZ6xftr9sSjZ7nY8qa
Date: Tue, 26 Jun 2012 04:25:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP7XX:  Remove omap730.h and omap850.h
Message-ID: <20120626112524.GF31393@atomide.com>
References: <1340013485.5611.6.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340013485.5611.6.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [120618 03:02]:
> No file includes omap730.h or omap850.h. That's not surprising, as
> commit e6684f7132c6e6333e96407b06910bebaa4c1935 ("OMAP7XX: Create
> omap7xx.h") created a header that was "intended to replace omap730.h and
> omap850.h", while all "values defined [in omap7xx.h] are identical to
> those in both the old files". So it seems it was just an oversight to
> keep both the old files after commit
> 7a8f48f8c611ac8c07023260258e2fec312b9242 ("OMAP7XX: omap_uwire.c:
> Convert to omap7xx.h") converted the last file still including one of
> those two old files.
> 
> Convert the last reference to omap730.h to a reference to omap7xx.h too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested only by using various git commands on the (history of the)
> tree.

Thanks, nice catch :) I'll apply this into fixes-non-critical.
 
> 1) A related cleanup could be to remove cpu_is_omap730 and
> cpu_is_omap850, as both macros seem unused.

Yes seems like we could do that. Care to do a patch for that?

Tony
