Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1IPR0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:26:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab1IPR0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:26:52 -0400
Date: Fri, 16 Sep 2011 19:25:09 +0200
From: Greg KH <gregkh@suse.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20110916172509.GA23960@suse.de>
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de>
 <op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
 <20110909184354.GA30278@suse.de>
 <20110916171824.GA23338@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916171824.GA23338@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 07:18:25PM +0200, Sebastian Andrzej Siewior wrote:
> * Greg KH | 2011-09-09 11:43:54 [-0700]:
> 
> >So we can expect more patches like this adding all of the possible
> >permutations of the different gadget devices?
> >
> >If so, ick, I thought that the work that was done was to prevent this
> >from happening, oh well :(
> 
> Would it be possible to come up with a gadget-hub driver which can have
> multiple gadget attached? This should get rid of this kind of gadget
> drivers, right?

I don't know, possibly, someone who knows the code better than I would
be the best to determine this.

greg k-h
