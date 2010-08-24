Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab0HXXV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:21:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab0HXXVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:21:22 -0400
Date: Tue, 24 Aug 2010 16:12:41 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100824231241.GA6971@suse.de>
References: <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
 <1277462596.2143.101.camel@itpsd6lap>
 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
 <1282683470.8020.66.camel@itpsd6lap>
 <20100824211016.GA7176@suse.de>
 <1282687797.8020.108.camel@itpsd6lap>
 <20100824222035.GA10625@suse.de>
 <1282690232.8020.116.camel@itpsd6lap>
 <20100824225703.GA5913@suse.de>
 <20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:22:21AM +0100, Alan Cox wrote:
> > No, it does cover that.  You should be able to do that with a simple
> > console redirection to /dev/kmsg  What happened when you tried to do
> > that?
> 
> stty: standard input: Inappropriate ioctl for device

Kay, how does systemd handle the kmsg console redirection?

> It's value is twofold
> 
> - formatting

Ick, we really want to format things from userspace here?

thanks,

greg k-h
