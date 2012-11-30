Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2K3BvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:51:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51653 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2K3BvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:51:14 -0500
Date: Thu, 29 Nov 2012 17:51:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 061/270] timekeeping: Cast raw_interval to u64 to avoid
 shift overflow
Message-ID: <20121130015110.GG13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-62-git-send-email-herton.krzesinski@canonical.com>
 <1354028907.4266.56.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354028907.4266.56.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:08:27PM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > commit 5b3900cd409466c0070b234d941650685ad0c791 upstream.
> > 
> > We fixed a bunch of integer overflows in timekeeping code during the 3.6
> > cycle.  I did an audit based on that and found this potential overflow.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Acked-by: John Stultz <johnstul@us.ibm.com>
> > Link: http://lkml.kernel.org/r/20121009071823.GA19159@elgon.mountain
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > [ herton: adapt for 3.5, timekeeper instead of tk pointer ]
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> This is also missing from 3.4; looks like Herton's version is
> applicable.

Thanks, now applied.

greg k-h
