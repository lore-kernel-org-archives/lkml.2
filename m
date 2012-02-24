Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab2BXU3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:29:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49679 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab2BXU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:29:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.102 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 12:27:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: =?utf-8?B?0JrQuNGA0LjQu9C7INCg0YPRgdC40L3QvtCy?= 
	<carasin.berlogue@mail.ru>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Take a look to this bug, please
Message-ID: <20120224202737.GA6230@kroah.com>
References: <E1S0xkw-0005Mj-4q.carasin-berlogue-mail-ru@f264.mail.ru>
 <20120224163151.GA8083@kroah.com>
 <CA+5PVA7p3eZnornsNa_dLZ9YLTy6WuFO3wpGbCZD4O9oFL=s=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7p3eZnornsNa_dLZ9YLTy6WuFO3wpGbCZD4O9oFL=s=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 03:25:44PM -0500, Josh Boyer wrote:
> On Fri, Feb 24, 2012 at 11:31 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > Also, have you tried the latest 3.3-rc4 kernel, it should have solved
> > this problem.
> 
> Could you perhaps elaborate on that part a bit?  I don't see any mention of
> RV420/520/720 support in samsung-laptop.c.  The last addition was for X520 and
> that is already in the kernel being run in the bug report.

There were patches posted that take the need for individual device
support for the driver out, so it should work for _all_ samsung laptops
properly.  I thought they were in the 3.3-rc kernel, if not, go bug the
platform driver maintainer to get them in, as they were sent far before
the merge window deadline :)

thanks,

greg k-h
