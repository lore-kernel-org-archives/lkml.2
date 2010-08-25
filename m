Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab0HYAkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:40:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:44815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0HYAku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:40:50 -0400
Date: Tue, 24 Aug 2010 17:41:34 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100825004134.GA28884@suse.de>
References: <20100625120329.1303aa61@lxorguk.ukuu.org.uk> <1282683470.8020.66.camel@itpsd6lap> <20100824211016.GA7176@suse.de> <1282687797.8020.108.camel@itpsd6lap> <20100824222035.GA10625@suse.de> <1282690232.8020.116.camel@itpsd6lap> <20100824225703.GA5913@suse.de> <20100825002221.68fc09a4@lxorguk.ukuu.org.uk> <20100824231241.GA6971@suse.de> <20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:51:52AM +0100, Alan Cox wrote:
> > > - formatting
> > 
> > Ick, we really want to format things from userspace here?
> 
> Depends what you are trying to do.
> 
> Put an embedded hat on
> 
> Do you want to be able to flip between a real debug interface and a
> logging device on the same software set without risking changing behaviour

I don't understand this point.

> Do you want to load a 70K daemon and an initrd or burn about 1.5K on a
> kernel interface ?

I'd rather burn 0K on the one we have today :)

Seriously, look at how Fedora 14 handles this, why can't you do the same
for embedded systems all from userspace, no additional code needed
anywhere.

thanks,

greg k-h
