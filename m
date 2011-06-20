Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1FTDUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 23:20:24 -0400
Received: from relais.videotron.ca ([24.201.245.36]:58648 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1FTDUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 23:20:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 19 Jun 2011 23:20:20 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Jesper Juhl <jj@chaosbits.net>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH][Trivial] ARM: remove duplicate include from
 arch/arm/mach-dove/common.c
In-reply-to: <alpine.LNX.2.00.1106162348320.8140@swampdragon.chaosbits.net>
Message-id: <alpine.LFD.2.00.1106192318310.2142@xanadu.home>
References: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net>
 <20110526144804.GA31651@lunn.ch>
 <alpine.LNX.2.00.1106162348320.8140@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Jesper Juhl wrote:

> On Thu, 26 May 2011, Andrew Lunn wrote:
> 
> > Jesper Juhl pointed out there is a redundant include of
> > linux/serial_8250.h. However it turns out both are redundant.
> > This patch removes them both.
> > 
> > Only compile tested.
> > 
> > Reported-by:  Jesper Juhl <jj@chaosbits.net>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Seems you are right.
> 
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>

Could this patch be sent to RMK's patch system if no one else 
picks it up please?
Thanks.


Nicolas
