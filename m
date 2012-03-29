Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab2C2R2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:28:17 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:25767 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2C2R2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:28:06 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OfBJ8Nc8qAypWMKnwjg+I
Date: Thu, 29 Mar 2012 10:28:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: mathieu.poirier@linaro.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 0/9] omap randconfig fixes for v3.3
Message-ID: <20120329172802.GX9859@atomide.com>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

* mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> [120323 10:16]:
> From: "Arnd Bergmann" <arnd@arndb.de>
> 
> The following is a set of patches that have been sent
> out during the 3.1 cycle that were not acked or merged.
> 
> Sending again for completeness.  
> 
> Tony, please pull if there are no objections:
> 
> The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

Can you please drop the already fixed ones and post
a new pull request?

It seems that these should merge fine to current mainline
if based on v3.3. If not, then maybe use the linux-omap fixes
branch as the base that I've just pushed at commit 2533c2cf.

Thanks,

Tony
