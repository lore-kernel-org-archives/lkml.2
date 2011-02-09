Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1BIVap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:30:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab1BIVao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:30:44 -0500
Date: Wed, 9 Feb 2011 13:27:10 -0800
From: Greg KH <gregkh@suse.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Arend van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>, Dowan Kim <dowan@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>, trivial@kernel.org
Subject: Re: [PATCH][trivial] Remove duplicate inclusion of wlc_event.h in
 drivers/staging/brcm80211/sys/wlc_mac80211.c
Message-ID: <20110209212710.GA751@suse.de>
References: <alpine.LNX.2.00.1102062249180.13593@swampdragon.chaosbits.net>
 <20110209194556.GA30200@kroah.com>
 <alpine.LNX.2.00.1102092218140.21858@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102092218140.21858@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:18:59PM +0100, Jesper Juhl wrote:
> On Wed, 9 Feb 2011, Greg KH wrote:
> 
> > On Sun, Feb 06, 2011 at 10:52:17PM +0100, Jesper Juhl wrote:
> > > We include wlc_event.h twice in 
> > > drivers/staging/brcm80211/sys/wlc_mac80211.c
> > > Once is enough.
> > 
> > Odd, this file isn't even in the linux-next tree anymore, what tree did
> > you make this against?
> > 
> Linus' tree - can't remember what HEAD was at when I made that patch, but 
> I probably pulled it the same day I sent the mail.

Please always send trivial stuff like this against linux-next, otherwise
it often times isn't relevant at all anymore.

thanks,

greg k-h
