Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0FIPen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:34:43 -0400
Received: from kroah.org ([198.145.64.141]:41024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab0FIPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:34:42 -0400
Date: Wed, 9 Jun 2010 08:33:51 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Xiaofan Chen <xiaofanc@gmail.com>, linux-usb@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 08/13] USB: gadget: g_serial: INF file updated
Message-ID: <20100609153351.GB21431@kroah.com>
References: <996015.66352.qm@web180311.mail.gq1.yahoo.com>
 <op.vd0y3ds37p4s8u@pikus>
 <AANLkTim6GHWVNvZ1XOJBZiu7ltl7TVpVJwVltLoKpYRi@mail.gmail.com>
 <op.vd014urd7p4s8u@pikus>
 <20100609145946.GB20543@kroah.com>
 <op.vd1g0kcc7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vd1g0kcc7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 05:22:58PM +0200, Michał Nazarewicz wrote:
> >>I dunno, obviously I want to make everything according to law to avoid
> >>any problems.  Maybe we should contact someone at The Software Freedom
> >>Law Center or some similar entity?
> 
> On Wed, 09 Jun 2010 16:59:46 +0200, Greg KH <greg@kroah.com> wrote:
> >Ick, no, that's not needed here.
> 
> Still I had a chat on IRC with a person who knows copyright law rather
> well[1] which pointed me to a few things. ;)
> 
> 
> >Take the copyright off if this is something that _you_ wrote.  If you
> >copied it from somewhere and modified it, say where you copied it from,
> >and show the rights that allowed you to copy it.
> >
> >Where exactly did you get it from originally?
> 
> The RNDIS template was taken from:
> http://msdn.microsoft.com/en-us/library/ff570620.aspx
> 
> The CDC ACM was sent by Xiaofan Chen who said that it is probably
> taken indirectly form MSDN as well.

Ok, and not from the Windows DDK, right?  That has a different license
than MSDN.

> The MSDN TOS reads:
> >If Microsoft makes any code marked as “sample” available on this
> >Web Site without a License Agreement, then that code is licensed
> >to you under the terms of the Microsoft Limited Public License.
> 
> Where the MLPL can be found at:
> <http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL>.  It seems like
> a perfectly legal free software license except point 3(F):
> 
> >(F) Platform Limitation- The licenses granted in sections 2(A) & 2(B)
> >extend only to the software or derivative works that you create that
> >run on a Microsoft Windows operating system product.
> 
> Also, 3(D) requires that the whole license is included:
> >(D) If you distribute any portion of the software in source code form,
> >you may do so only under this license by including a complete copy of
> >this license with your distribution. If you distribute any portion of
> >the software in compiled or object code form, you may only do so under
> >a license that complies with this license.
> 
> Therefore, shall we include the license along with the INFs and ignore
> the fact it's not fully free software?

No, it's not "software" here, and it is abiding by the license of the
MLPL as you don't run that file on any non-Windows machine.

How about putting the following on the file:
	; based on a example .inf file that was:
	;	Copyright (c) Microsoft Corporation
	; and released under the MLPL as found at
	; http://msdn.microsoft.com/en-us/cc300389.aspx#MLPL
	; For use only on Windows operating systems.
	;

Interesting that they don't put a date on the copyright.

With that wording, I'd be glad to take it.

thanks,

greg k-h
