Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0IDOnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:43:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0IDOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:42:58 -0400
Date: Sat, 4 Sep 2010 07:38:12 -0700
From: Greg KH <gregkh@suse.de>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] serial: amba-pl010: fix set_ldisc
Message-ID: <20100904143812.GA13340@suse.de>
References: <1283101965-12161-1-git-send-email-mika.westerberg@iki.fi> <20100904072323.GR25559@gw.healthdatacare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100904072323.GR25559@gw.healthdatacare.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 10:23:23AM +0300, Mika Westerberg wrote:
> On Sun, Aug 29, 2010 at 08:12:45PM +0300, Mika Westerberg wrote:
> > Commit d87d9b7d1 ("tty: serial - fix tty referencing in set_ldisc") changed
> > set_ldisc to take ldisc number as parameter. This patch fixes AMBA PL010 driver
> > according the new prototype.
> 
> Hi,
> 
> If there are no objections, could this be merged? I CC'd Greg as I'm not sure
> who is the serial maintainer.

I've been acting as the def-facto serial maintainer, so I can take it.
I'll queue it up in my tree, give me a few days till I get to it.

thanks,

greg k-h
