Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2KZSok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:44:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:56467 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab2KZSoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:44:38 -0500
Date: Mon, 26 Nov 2012 10:44:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Michael D. Burkey" <mdburkey@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Christoph Fritz <chf.fritz@googlemail.com>,
        Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [ 35/83] ARM: imx: ehci: fix host power mask bit
Message-ID: <20121126184436.GB21012@kroah.com>
References: <20121122004212.371862690@linuxfoundation.org>
 <20121122004216.531273574@linuxfoundation.org>
 <8DA3043795C340758B9AEB1BCA791676@Chronos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DA3043795C340758B9AEB1BCA791676@Chronos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:52:25PM -0500, Michael D. Burkey wrote:
> This patch is definitely needed -- it is obviously setting the wrong
> bit --  but I am still doing testing to see what other complications
> may arise from actually setting the RIGHT bit (i.e. I've seen some
> odd results so far and suspect some other code may have been changed
> historically to account for the wrong behaviour this bit was
> causing).
> 
> We're currently on vacation for Thanksgiving over here in the USA
> and I won't be back in the office til next week.
> 
> If you would, hold off on adding the patch to the stable kernel
> until I have a bit more time to check out a couple of things.

As it's already in Linus's tree, one would have hoped that the patch
would have been tested already :)

I'll leave it in the stable tree, if it's a problem, please get the fix
into Linus's tree, and then have that fix submitted to the stable kernel
trees.

thanks,

greg k-h
