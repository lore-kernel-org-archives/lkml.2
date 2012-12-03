Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2LCPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:17:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33661 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2LCPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:17:18 -0500
Date: Mon, 3 Dec 2012 07:19:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: fix compilation warning
Message-ID: <20121203151911.GA3359@kroah.com>
References: <1354530848-12516-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354530848-12516-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:34:08AM +0000, Cong Ding wrote:
> We do not allow old-style function definition.  Always spell foo(void) if
> a function does not take any parameters.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/staging/telephony/ixj.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

As Dan pointed out, you have to work against linux-next, otherwise you
waste time fixing things that might not even be in the tree anymore,
like this code.

sorry,

greg k-h
