Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1ASWVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:21:47 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28131 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab1ASWVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:21:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Yf1gCV8XLX8JxFVSCWlh7
Date: Wed, 19 Jan 2011 14:21:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-omap@vger.kernel.org, Daniel Morsing <daniel.morsing@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        charu@ti.com, sshtylyov@mvista.com
Subject: Re: [PATCHv4 2/4] OMAP3: Devkit8000: Fix tps65930 pullup/pulldown
 configuration
Message-ID: <20110119222126.GI4957@atomide.com>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
 <1295425166-25540-3-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295425166-25540-3-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <weber@corscience.de> [110119 00:18]:
> From: Daniel Morsing <daniel.morsing@gmail.com>
> 
> gpio7 on the tps65930 is used as an output on the devkit8000 and
> gpio1 is not connected. Remove gpio7 and change gpio1 to pulldown
> 
> Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>

I'll queue only this fix for now, looks like the other still need
minor changes.

Tony
