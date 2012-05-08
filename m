Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2EHWmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:42:37 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49887 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2EHWmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:42:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ngt0RQaN816tcJ4xPB0Gg
Date: Tue, 8 May 2012 15:42:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Subject: Re: [PATCH 1/2] input: keypad: move platform_data to
 <linux/platform_data>
Message-ID: <20120508224230.GO5088@atomide.com>
References: <1331905159-11255-1-git-send-email-sourav.poddar@ti.com>
 <1331905159-11255-2-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331905159-11255-2-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sourav Poddar <sourav.poddar@ti.com> [120316 06:43]:
> From: Felipe Balbi <balbi@ti.com>
> 
> This patch allows us to drop the OMAP depencendy
> from the OMAP4 keypad driver.

Seems safe to apply via linux-input:

Acked-by: Tony Lindgren <tony@atomide.com>
