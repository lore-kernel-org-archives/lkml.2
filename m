Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1FQKB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 06:01:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1FQKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 06:01:57 -0400
Date: Fri, 17 Jun 2011 12:01:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH][Trivial] ARM: remove duplicate include from
 arch/arm/mach-dove/common.c
In-Reply-To: <alpine.LNX.2.00.1106162348320.8140@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106171201210.22872@pobox.suse.cz>
References: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net> <20110526144804.GA31651@lunn.ch> <alpine.LNX.2.00.1106162348320.8140@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Jesper Juhl wrote:

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

I don't seem to be able to find the patch anywhere during a quick search 
of the archives. Could you please bounce it to me (in case it hasn't been 
already applied elsewhere)?

Thanks,

-- 
Jiri Kosina
SUSE Labs
