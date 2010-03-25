Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0CYO0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:26:51 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754447Ab0CYO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:26:50 -0400
Date: Thu, 25 Mar 2010 15:26:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>, netdev@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.34-rc1: bluetooth oops
Message-ID: <20100325142640.GA1602@ucw.cz>
References: <20100314201434.GE22059@elf.ucw.cz> <1268598500.3897.36.camel@localhost.localdomain> <20100314204434.GB5208@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314204434.GB5208@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-14 21:44:34, Pavel Machek wrote:
> Hi!
> 
> > > I got this after trying to use bnep for few minutes... Machine locked
> > > after that, not sure if it is related.
> > 
> > I can't explain it since we haven't changed the BNEP code. So that might
> > be a problem in the networking layer. So posting it to netdev might be a
> > good idea.
> 
> Ok, I'll try using bnep some more. I had bad problems with cellphone
> connection at that point, so maybe it is not easy to repeat, and it
> the fact I have not seen it before may not mean much...

So it seems to repeat about twice a week, definitely a regression :-(.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
