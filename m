Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0JGTWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:22:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40277 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0JGTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:22:54 -0400
Date: Thu, 7 Oct 2010 20:22:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101007192245.GC26435@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
> Many drivers are broken, and there's no alternative in sight. Such a big
> change should stay as a warning for now, and only later should it
> actually fail.
> 
> The drivers are not doing something correct, we get it, but for now it's
> better to allow them to work (they do 99% of the time anyway) rather
> than to force everyone to revert this patch in their internal trees
> until there's a solution. A slightly broken functionality is better than
> no functionality at all.
> 
> A warning lets people know that what they are doing is not right, and
> they should fix it.

So what are _you_ going to do to fix these drivers?  Continue reverting
this patch?  Or are you just going to ignore the issue entirely?

Unless people can come up with a plan to fix their drivers using ioremap
on system RAM thereby violating the architecture specification, I'm
_not_ going to apply this patch.
