Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041Ab1FPWAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:00:18 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14841 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039Ab1FPWAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:00:15 -0400
Date: Thu, 16 Jun 2011 23:51:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andrew Lunn <andrew@lunn.ch>
cc: linux-arm-kernel@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH][Trivial] ARM: remove duplicate include from
 arch/arm/mach-dove/common.c
In-Reply-To: <20110526144804.GA31651@lunn.ch>
Message-ID: <alpine.LNX.2.00.1106162348320.8140@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net> <20110526144804.GA31651@lunn.ch>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Andrew Lunn wrote:

> Jesper Juhl pointed out there is a redundant include of
> linux/serial_8250.h. However it turns out both are redundant.
> This patch removes them both.
> 
> Only compile tested.
> 
> Reported-by:  Jesper Juhl <jj@chaosbits.net>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Seems you are right.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

