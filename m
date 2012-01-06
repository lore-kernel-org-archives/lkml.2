Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2AFFFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 00:05:52 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37820 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab2AFFFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 00:05:50 -0500
X-Sasl-enc: /1UxXgMb67fuUYO0ttniEXhaQh8oWt87BVsmPFcdcqsJ 1325826349
Date: Thu, 5 Jan 2012 21:03:55 -0800
From: Greg KH <greg@kroah.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: netdev@vger.kernel.org, gwingerde@gmail.com, larry.finger@lwfinger.net,
        davem@davemloft.net, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
Message-ID: <20120106050355.GA7633@kroah.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
 <20120105223933.GA10268@kroah.com>
 <CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 11:18:28PM -0200, Fabio Estevam wrote:
> On Thu, Jan 5, 2012 at 8:39 PM, Greg KH <greg@kroah.com> wrote:
> 
> > Are you sure that this isn't getting confused with the
> > drivers/char/misc.c interface instead of the "throw a bunch of randome
> > drivers into drivers/misc/" issue?
> 
> Sorry, I am not aware of this issue.
> 
> > Why would anything ever want to select MISC_DEVICES?  What happens if
> > you just remove that select line from the Kconfig?
> 
> Yes, I don´t understand the point of allowing the selection MISC_DEVICES.
> 
> IMHO it is potential for causing dependency issues.

Then remove that selection.  Nothing should be depending on a misc
driver, if it is, then that implies that this is more than just a "misc"
driver, and it should be moved elsewhere.

thanks,

greg k-h
