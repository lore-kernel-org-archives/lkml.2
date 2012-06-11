Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2FKXmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:42:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39017 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2FKXmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:42:08 -0400
Date: Mon, 11 Jun 2012 16:42:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete seven tty headers
Message-ID: <20120611234204.GA17383@kroah.com>
References: <1339145808.25798.28.camel@x61.thuisdomein>
 <4FD1DB30.80307@suse.cz>
 <1339155706.25798.55.camel@x61.thuisdomein>
 <201206081403.16608.arnd@arndb.de>
 <4FD5E7B8.1020502@suse.cz>
 <20120611135306.537757d2@pyramind.ukuu.org.uk>
 <20120611234033.GB17313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611234033.GB17313@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:40:33PM -0700, Greg Kroah-Hartman wrote:
> On Mon, Jun 11, 2012 at 01:53:06PM +0100, Alan Cox wrote:
> > > I agree (I wrote I doubt there are any users at all). But I would prefer
> > > going through the deprecation phase (adding a #warning) anyway. Removing
> > > the headers completely in a year, or maybe sooner is OK then.
> > 
> > I really see no point. Distributions are going to build against a set of
> > headers generated from a kernel, once at the time the distribution is
> > first assembled (eg the kernel-headers package in Fedora).
> 
> I agree, I'll take this patch now as the drivers are gone, the headers
> should be as well.

Although, as this originally happened in 3.1, I think it's safe to wait
for 3.6 for this patch to go in, no rush for 3.5.

thanks,

greg k-h
