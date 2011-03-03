Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab1CCVGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:06:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:52831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665Ab1CCVGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:06:53 -0500
Date: Thu, 3 Mar 2011 13:06:26 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2011-03-02-16-52 uploaded (linux-next:
 drivers/staging/epca - missing header files)
Message-ID: <20110303210626.GA32441@suse.de>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
 <20110303125012.2a7218d4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303125012.2a7218d4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 12:50:12PM -0800, Randy Dunlap wrote:
> On Wed, 02 Mar 2011 16:52:55 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.38-rc7:
> 
> 
> Who did the (incomplete) move of some tty drivers to staging? (in linux-next)

That would be me :)

> Please also move drivers/char/digi*.h
> 
> #include "digiPCI.h"
> #include "digi1.h"
> #include "digiFep1.h"
> =>
> drivers/staging/tty/epca.c:46:21: error: digiPCI.h: No such file or directory
> drivers/staging/tty/epca.c:49:19: error: digi1.h: No such file or directory
> drivers/staging/tty/epca.c:50:22: error: digiFep1.h: No such file or directory
> 
> causes over 100 build errors.

Crap, sorry, thanks for pointing it out, will go fix this right now.

greg k-h
