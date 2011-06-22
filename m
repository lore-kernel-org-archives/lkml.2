Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab1FVUAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:00:14 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:55814 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758551Ab1FVUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:00:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADFIAk5tgwPS/2dsb2JhbABTpxB4iHMCwH0Ohh8EoXg
Date: Wed, 22 Jun 2011 22:00:09 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 8/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622200009.GC26745@infomag.iguana.be>
References: <20110618172637.GI3441@infomag.iguana.be> <201106182109.14520.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106182109.14520.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> On Saturday 18 June 2011 19:26:37 Wim Van Sebroeck wrote:
> > 
> > watchdog: WatchDog Timer Driver Core - Part 8
> >    
> > Add support for a parent device so that it can
> > be set as the parent of the misc_device.
> > 
> > Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> How about folding this patch into the first one? It hardly adds any code 
> as much as it replaces some lines with others.

prefer to not do that for following reasons:
1) I deliberately splitted the framework in a series of patches, so that people
understand better what the differen developmentt steps have been historically
and/or logically. By splitting it, I hope that people will understand better
why the API is what it is.
2) most watchdog drivers don't do this yet. So this teaches existing device
driver writers also that this is a possible feature.

Kind regards,
Wim.

