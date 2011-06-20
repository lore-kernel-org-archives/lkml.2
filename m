Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1FTIlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:41:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:41979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1FTIlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:41:04 -0400
Date: Mon, 20 Jun 2011 10:40:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Jesper Juhl <jj@chaosbits.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH][Trivial] ARM: remove duplicate include from
 arch/arm/mach-dove/common.c
In-Reply-To: <alpine.LFD.2.00.1106192318310.2142@xanadu.home>
Message-ID: <alpine.LNX.2.00.1106201040480.11049@pobox.suse.cz>
References: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net> <20110526144804.GA31651@lunn.ch> <alpine.LNX.2.00.1106162348320.8140@swampdragon.chaosbits.net> <alpine.LFD.2.00.1106192318310.2142@xanadu.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011, Nicolas Pitre wrote:

> > > Jesper Juhl pointed out there is a redundant include of
> > > linux/serial_8250.h. However it turns out both are redundant.
> > > This patch removes them both.
> > > 
> > > Only compile tested.
> > > 
> > > Reported-by:  Jesper Juhl <jj@chaosbits.net>
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > Seems you are right.
> > 
> > Reviewed-by: Jesper Juhl <jj@chaosbits.net>
> 
> Could this patch be sent to RMK's patch system if no one else 
> picks it up please?

I have picked it up last week.

-- 
Jiri Kosina
SUSE Labs
