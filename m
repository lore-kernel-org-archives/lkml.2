Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1AJQF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:05:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:33049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1AJQFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:05:21 -0500
Date: Mon, 10 Jan 2011 07:55:33 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        Russell Coker <russell@coker.com.au>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] char nvtty: Network Virtual Terminal support
Message-ID: <20110110155533.GA3914@suse.de>
References: <1294664819-17960-1-git-send-email-giometti@linux.it>
 <1294664819-17960-2-git-send-email-giometti@linux.it>
 <20110110131332.622e8a0d@lxorguk.ukuu.org.uk>
 <20110110133055.GM23771@enneenne.com>
 <20110110134955.05d0d8a1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110134955.05d0d8a1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 01:49:55PM +0000, Alan Cox wrote:
> > If I well understood the pty/tty pair modem lines they can be used to
> > send receive serial data but they cannot be used to set the serial
> > parameters since the slave doesn't send to the master the serial
> > settings a userland application does on it, doesn't it?
> 
> Currently this is the case.
> 
> > > Otherwise its a very nice implementation of something I don't think we
> > > should have implemented in the kernel.
> > 
> > Thanks, but I still don't understand how I can set the serial settings
> > without a specific tty driver and just using the pty/tty pair modem
> > lines... :'(
> 
> I'd rather see either tweaks to the pty/tty code to support this and
> modem line setting, or something like your nvt which can be used for
> arbitary protocols rather than being tied to the nvt telnet protocol
> limits.

I also agree with this, we don't want to force the protocol to be this
one, userspace has access to many good, secure protocols, that should be
able to be used instead if they want to.

thanks,

greg k-h
