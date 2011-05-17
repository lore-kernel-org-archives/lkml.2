Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1EQSps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:45:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49401 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1EQSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:45:47 -0400
Date: Tue, 17 May 2011 19:45:27 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, alan@linux.intel.com
Subject: Re: [PATCHv2 1/2] amba pl011: workaround for uart registers lockup
Message-ID: <20110517184527.GC15422@flint.arm.linux.org.uk>
References: <20110516172958.GA13011@kroah.com> <1305609617-9524-1-git-send-email-shreshthakumar.sahu@stericsson.com> <20110517182356.GA17703@kroah.com> <20110517183015.GA15422@flint.arm.linux.org.uk> <20110517184019.GA31727@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517184019.GA31727@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 11:40:19AM -0700, Greg KH wrote:
> On Tue, May 17, 2011 at 07:30:15PM +0100, Russell King wrote:
> > On Tue, May 17, 2011 at 11:23:56AM -0700, Greg KH wrote:
> > > Why?  You don't use these callbacks in this driver, so why add them?
> > 
> > Did you look at the second patch?
> 
> The second patch was not sent to me, so I couldn't have seen it :(

Ok, I've just forwarded you the second patch.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
