Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0IDCOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:14:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:51783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0IDCOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:14:32 -0400
Date: Fri, 3 Sep 2010 19:05:36 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Vipin Mehta <vmehta@atheros.com>
Subject: Re: linux-next: Tree for September 3 (ar6k)
Message-ID: <20100904020536.GA6204@suse.de>
References: <20100903135206.d9bc2093.sfr@canb.auug.org.au> <20100903180614.81e5eee0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903180614.81e5eee0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 06:06:14PM -0700, Randy Dunlap wrote:
> On Fri, 3 Sep 2010 13:52:06 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100902:
> 
> 
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:29:43: error: AR6002/hw2.0/hw/mbox_host_reg.h: No such file or directory
> 
> which leads to lots of these (this is just a sample):
> 
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:227: error: implicit declaration of function 'INT_STATUS_ENABLE_ERROR_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:228: error: implicit declaration of function 'INT_STATUS_ENABLE_CPU_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:229: error: implicit declaration of function 'INT_STATUS_ENABLE_COUNTER_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:232: error: implicit declaration of function 'INT_STATUS_ENABLE_MBOX_DATA_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:245: error: implicit declaration of function 'CPU_INT_STATUS_ENABLE_BIT_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:249: error: implicit declaration of function 'ERROR_STATUS_ENABLE_RX_UNDERFLOW_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:250: error: implicit declaration of function 'ERROR_STATUS_ENABLE_TX_OVERFLOW_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:254: error: implicit declaration of function 'COUNTER_INT_STATUS_ENABLE_BIT_SET'
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:263: error: 'INT_STATUS_ENABLE_ADDRESS' undeclared (first use in this function)
> drivers/staging/ath6kl/htc2/AR6000/ar6k.c:296: error: 'INT_STATUS_ENABLE_ADDRESS' undeclared (first use in this function)

Vipin, can you please take care of this?

thanks,

greg k-h
