Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0GTK5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:57:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46566 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0GTK5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vMiqTEI9gopdIj8m2Rkc+1M4PyPueaG7L9zYD3QQ6QMHgTQ74OEFY+cnRTtmXyGEYx
         T+kbDsbVgnPjBdg9SuDhU9Y7Jx/cH7/odWoMHKWLq5eNoUfd9w6nXCEaJ8EgJjAJcTxR
         Lk0S+fBP/lRSWyFQctyZo80umKuuqbgYfAlTA=
Date: Tue, 20 Jul 2010 14:57:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Yulia Vilensky <vilensky@compulab.co.il>,
        Geert Stappers <stappers@stappers.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ds2782_battery: Rename get_current and get_voltage
 operations
Message-ID: <20100720105712.GA20366@oksana.dev.rtsoft.ru>
References: <1279584175.4883.226.camel@localhost>
 <20100720074659.GA32073@oksana.dev.rtsoft.ru>
 <1279619066.4883.249.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1279619066.4883.249.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 10:44:26AM +0100, Ben Hutchings wrote:
> On Tue, 2010-07-20 at 11:46 +0400, Anton Vorontsov wrote:
> > On Tue, Jul 20, 2010 at 01:02:55AM +0100, Ben Hutchings wrote:
> > > commit 9b9ade6b612e562c4a5bd02ef38cc32e10f3f9ba "ds2782_battery: Add
> > > support for ds2786 battery gas gauge" introduced an operation named
> > > get_current.  Since get_current() is defined as a macro on some
> > > architectures this driver no longer compiles on those architectures.
> > > 
> > > Rename get_current to get_current_now to avoid the macro.
> > > Rename get_voltage to get_voltage_now for consistency.
> > > 
> > > Reported-by: Geert Stappers <stappers@stappers.nl>
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > 
> > Thanks for the patch, but I have a similar fix in the
> > battery-2.6.git tree (for -next):
> [...]
> 
> This fix needs to go into 2.6.35.

Did you read why I don't push it into 2.6.35? Reread my email,
pay attention to the very bottom.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
