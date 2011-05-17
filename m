Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab1EQSli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:41:38 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51747 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165Ab1EQSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:41:37 -0400
X-Sasl-enc: QvGirKFh1jutvE9DwVcH7e4WVnddZWghlUl+oggEZ5BZ 1305657695
Date: Tue, 17 May 2011 11:40:19 -0700
From: Greg KH <greg@kroah.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, alan@linux.intel.com
Subject: Re: [PATCHv2 1/2] amba pl011: workaround for uart registers lockup
Message-ID: <20110517184019.GA31727@kroah.com>
References: <20110516172958.GA13011@kroah.com>
 <1305609617-9524-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20110517182356.GA17703@kroah.com>
 <20110517183015.GA15422@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517183015.GA15422@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 07:30:15PM +0100, Russell King wrote:
> On Tue, May 17, 2011 at 11:23:56AM -0700, Greg KH wrote:
> > Why?  You don't use these callbacks in this driver, so why add them?
> 
> Did you look at the second patch?

The second patch was not sent to me, so I couldn't have seen it :(

thanks,

greg k-h
