Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1LEWsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:48:09 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10044 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1LEWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:48:07 -0500
Date: Mon, 5 Dec 2011 23:48:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <greg@kroah.com>
cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] [staging] iio, adc: Do not leak memory in
 ad7280_event_handler()
In-Reply-To: <20111127004325.GA21259@kroah.com>
Message-ID: <alpine.LNX.2.00.1112052347440.7382@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1111062246580.5763@swampdragon.chaosbits.net> <20111127004325.GA21259@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Nov 2011, Greg KH wrote:

> On Sun, Nov 06, 2011 at 10:49:22PM +0100, Jesper Juhl wrote:
> > If ad7280_read_all_channels() returns <0 then we'll leak the memory
> > allocated to 'channels' when we return and that variable goes out of
> > scope.
> > This patch fixes the leak.
> 
> This patch no longer applies to my tree, can you redo it against the
> next linux-next release and resend it?
> 
> thanks,
> 
> greg k-h

Sure. I'll take a look at it this weekend.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

