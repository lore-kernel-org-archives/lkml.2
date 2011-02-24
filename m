Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1BXVXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:23:50 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:20106 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1BXVXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:23:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+AFOojbeu8wOWEa/jiGx98
Date: Thu, 24 Feb 2011 13:23:39 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Guruswamy, Senthilvadivu" <svadivu@ti.com>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-ID: <20110224212339.GM20560@atomide.com>
References: <20110221141650.71b433b7.sfr@canb.auug.org.au>
 <1298278062.4931.19.camel@deskari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298278062.4931.19.camel@deskari>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Tomi Valkeinen <tomi.valkeinen@ti.com> [110221 00:46]:
> 
> Tony, do you have such a semi-stable branch I could use as a base? Or
> any other ideas?

I guess you already figured this out.. The omap-for-linus branch should
have immutable commits. So you can merge with the earliest commit that
does the job for you from there.

Regards,

Tony
