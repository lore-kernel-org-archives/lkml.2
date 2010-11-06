Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0KFQft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:35:49 -0400
Received: from kroah.org ([198.145.64.141]:44509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0KFQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:35:47 -0400
Date: Sat, 6 Nov 2010 09:34:29 -0700
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] [USB] UAS: Achitecture; TMF; more
Message-ID: <20101106163429.GA5024@kroah.com>
References: <20101106051447.GA2327@kroah.com> <87456.32791.qm@web31801.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87456.32791.qm@web31801.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 11:52:00PM -0700, Luben Tuikov wrote:
> --- On Fri, 11/5/10, Greg KH <greg@kroah.com> wrote:
> > > This patch changes 86% of the driver. More is to come,
> > but this is
> > > a self-contained patch so it can be applied.
> > 
> > No it can not at all, sorry.
> 
> Greg, would you accept a brand new driver, say uastoo.c (just like
> 8139too.c came about, remember?), or would you say "This is 14% the same
> as uas.c, and thus cannot go in"?

I will say that as you and Mathew need to work together here.

> Did Willy reply to your query about the previous patches? I didn't see
> his reply.

If he did, I did not see his reply either.

I now have a UAS device so I will test your other patches out next week,
and if Matthew is still absent, will have to determine to apply them or
not.

thanks,

greg k-h
