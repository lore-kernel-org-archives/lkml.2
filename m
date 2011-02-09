Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1BIVUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:20:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24140 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1BIVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:20:11 -0500
Date: Wed, 9 Feb 2011 22:18:59 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <greg@kroah.com>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Arend van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>, Dowan Kim <dowan@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>, trivial@kernel.org
Subject: Re: [PATCH][trivial] Remove duplicate inclusion of wlc_event.h in
 drivers/staging/brcm80211/sys/wlc_mac80211.c
In-Reply-To: <20110209194556.GA30200@kroah.com>
Message-ID: <alpine.LNX.2.00.1102092218140.21858@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062249180.13593@swampdragon.chaosbits.net> <20110209194556.GA30200@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Greg KH wrote:

> On Sun, Feb 06, 2011 at 10:52:17PM +0100, Jesper Juhl wrote:
> > We include wlc_event.h twice in 
> > drivers/staging/brcm80211/sys/wlc_mac80211.c
> > Once is enough.
> 
> Odd, this file isn't even in the linux-next tree anymore, what tree did
> you make this against?
> 
Linus' tree - can't remember what HEAD was at when I made that patch, but 
I probably pulled it the same day I sent the mail.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

