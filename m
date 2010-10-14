Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0JNTPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:15:30 -0400
Received: from kroah.org ([198.145.64.141]:57677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab0JNTP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:15:29 -0400
Date: Thu, 14 Oct 2010 12:14:47 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de
Subject: Re: mmotm 2010-10-13-17-13 uploaded (staging/bcm)
Message-ID: <20101014191447.GF11510@kroah.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
 <20101013211754.ba0d84f5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013211754.ba0d84f5.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:17:54PM -0700, Randy Dunlap wrote:
> On Wed, 13 Oct 2010 17:13:25 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.36-rc7:
> 
> 
> drivers/staging/bcm/Bcmnet.c:24: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:24: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:24: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:26: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:31: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:31: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:31: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:33: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:34: error: 'struct net_device' has no member named 'refcnt'
> drivers/staging/bcm/Bcmnet.c:35: error: 'struct net_device' has no member named 'refcnt'

Very wierd, is this coming from some other net_device structure change
in linux-next or mm?

thanks,

greg k-h
