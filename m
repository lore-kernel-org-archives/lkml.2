Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2IEUXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:23:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759280Ab2IEUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:23:22 -0400
Date: Wed, 5 Sep 2012 13:20:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial: Remove orphaned header sc26198.h
Message-ID: <20120905202048.GA17716@kroah.com>
References: <1345564193-25994-1-git-send-email-shc_work@mail.ru>
 <1345567392.4564.30.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345567392.4564.30.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 06:43:12PM +0200, Paul Bolle wrote:
> On Tue, 2012-08-21 at 19:49 +0400, Alexander Shiyan wrote:
> > This header was used by the driver "stallion", but the driver has
> > been removed as a result of migration 2.4 -> 2.6 and the header is
> > still present in the system and is not currently used by any driver.
> > We can safely remove it.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  include/linux/sc26198.h |  533 -----------------------------------------------
> 
> commit afbaade3dc99838a0c39699bea175674f27322a1 ("delete seven tty
> headers"), in - I think - tty.git's tty-next branch, already deleted
> this and six other headers.

Yes, this patch doesn't apply to the tty-next branch for that very
reason.

In the future Alexander, please try working off of the linux-next tree,
that's the best place for stuff like this.

greg k-h
