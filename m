Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0ENPAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:00:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:56908 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab0ENPAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:00:43 -0400
Date: Fri, 14 May 2010 17:00:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Florian Fainelli <florian@openwrt.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Eugene Konev <ejka@imfi.kspu.ru>
Subject: Re: [PATCH] vlynq: make whole Kconfig-menu dependant on
 architecture
In-Reply-To: <201005141605.01692.florian@openwrt.org>
Message-ID: <alpine.LNX.2.00.1005141700300.28092@pobox.suse.cz>
References: <1273844445-15508-1-git-send-email-w.sang@pengutronix.de> <201005141605.01692.florian@openwrt.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Florian Fainelli wrote:

> On Friday 14 May 2010 15:40:45 Wolfram Sang wrote:
> > This removes an empty menu for most platforms.
> > 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> Acked-by: Florian Fainelli <florian@openwrt.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
