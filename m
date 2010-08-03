Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0HCHV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:21:56 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50211 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0HCHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:21:55 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/APUnguxH6fgtCXr6aTuXG
Date: Tue, 3 Aug 2010 10:22:11 +0300
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP2: powerdomain: Add break in switch statement
Message-ID: <20100803072210.GQ12293@atomide.com>
References: <1278661253-22185-1-git-send-email-weber@corscience.de>
 <alpine.DEB.2.00.1007121418220.10106@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007121418220.10106@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [100712 23:14]:
> On Fri, 9 Jul 2010, Thomas Weber wrote:
> 
> > Add a missing break at end of switch statement. At the moment it is a
> > fall through to WARN_ON(1) and return -EEXIST.
> > 
> > Signed-off-by: Thomas Weber <weber@corscience.de>
> 
> Thanks Thomas.
> 
> Tony, this is
> 
> Acked-by: Paul Walmsley <paul@pwsan.com>
> 
> if you want it for .36; otherwise, can queue it for .37 here.

Thanks, I've added it into omap-for-linus.

Regards,

Tony
