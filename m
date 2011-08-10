Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1HJLy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:54:27 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:46316 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753019Ab1HJLy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:54:26 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19mtEhR+8Z7cCJbLUC/Hf2i
Date: Wed, 10 Aug 2011 04:54:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mach-omap2: mux: use kstrdup()
Message-ID: <20110810115423.GI1939@atomide.com>
References: <1312622953.5589.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312622953.5589.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Meyer <thomas@m3y3r.de> [110806 02:24]:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use kstrdup rather than duplicating its implementation

Thanks applying to fixes.

Regards,

Tony
