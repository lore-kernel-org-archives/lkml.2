Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2AGKUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 05:20:39 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:63425 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab2AGKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 05:20:37 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAMUaCE9R8tOI/2dsb2JhbABDrEGBBoFyAQEEATocIxAIAw44FCUDIYgNArYBE4t+BJUIiR+JHA
Date: Sat, 7 Jan 2012 11:20:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Vertes <marc.vertes@sigfox.com>, linux-watchdog@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 28 (via_wdt)
Message-ID: <20120107102034.GI23376@infomag.iguana.be>
References: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au> <4EFB5BF2.3020600@xenotime.net> <20111228175751.GA14460@infomag.iguana.be> <4F07B291.4040608@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F07B291.4040608@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> >> via_wdt needs a MODULE_LICENSE():
> >>
> >> WARNING: modpost: missing MODULE_LICENSE() in drivers/watchdog/via_wdt.o
> >> see include/linux/module.h for more information
> > 
> > Fixed.
> 
> Not yet in linux-next ??

I noticed it yesterday afternoon also. So I "re-fixed" (and double-checked) it yesterday in the afternoon.
So will be in linux-next with the next pull.

Kind regards,
Wim.

