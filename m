Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1KHOZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:25:14 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55483 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874Ab1KHOZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:25:11 -0500
X-Sasl-enc: XlEczOlqXe/Fk5tnAOnHQ72+vtdNg8o4Ys8CDDhFhNPl 1320762310
Date: Tue, 8 Nov 2011 06:24:32 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some
 variables
Message-ID: <20111108142432.GA11293@kroah.com>
References: <4E492CFF.7040905@pwrnet.de>
 <20110822211832.GA8023@kroah.com>
 <4EB3A009.10502@evidence.eu.com>
 <4EB8F6B9.6010008@atmel.com>
 <4EB90902.4030200@evidence.eu.com>
 <20111108134804.07095c5d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108134804.07095c5d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 01:48:04PM +0000, Alan Cox wrote:
> > The modifications that I have proposed are very minimal, and most 
> > user-space code should continue to work without any difference. Any Cris 
> > user-space code will continue to work, because we didn't change the 
> > behavior of the driver. For Atmel user-space code, instead, the behavior 
> > of the driver changes only if flags are not set and delay variables 
> > contain a value different than 0 (which, hopefully, is not a very common 
> > situation). That's the reason why I preferred to not change the names of 
> > the variables, even if better names would be desirable.
> 
> We have inconsistency between implementations. We don't have a change in
> implementation. There isn't any way to resolve that except by fixing the
> deviating implementation and doing it promptly.
> 
> With my tty hat on I'm quite happy with this patch. The sooner it is
> upstream the better.

Ok, I'll push to get it to Linus for the next rc release.

greg k-h
