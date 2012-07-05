Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2GEDZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:25:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55628 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752075Ab2GEDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:25:51 -0400
Message-ID: <1341458750.2058.15.camel@joe2Laptop>
Subject: Re: [PATCH 4 2/4] NET ethernet introduce mac_platform helper
From: Joe Perches <joe@perches.com>
To: Andy Green <andy.green@linaro.org>
Cc: linux-omap@vger.kernel.org, s-jan@ti.com, arnd@arndb.de,
        patches@linaro.org, tony@atomide.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 04 Jul 2012 20:25:50 -0700
In-Reply-To: <4FF507FF.3000604@linaro.org>
References: <20120705024259.26317.16000.stgit@build.warmcat.com>
	 <20120705024446.26317.49693.stgit@build.warmcat.com>
	 <1341457963.2058.13.camel@joe2Laptop> <4FF507FF.3000604@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 11:20 +0800, Andy Green wrote:
> On 05/07/12 11:12, the mail apparently from Joe Perches included:
[]
> >> diff --git a/net/ethernet/mac-platform.c b/net/ethernet/mac-platform.c
> > []
> >> +static int mac_platform_netdev_event(struct notifier_block *this,
> >> +						unsigned long event, void *ptr)
> >
> > alignment to parenthesis please.
> 
> OK.  Although different places in the kernel seem to have different 
> expectations about that.

net and drivers/net is pretty consistent.
Most of the exceptions are old code.
Some of those exceptions are being slowly updated too.

cheers, Joe

