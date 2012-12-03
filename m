Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2LCK4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:56:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25411 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2LCK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:56:44 -0500
Date: Mon, 3 Dec 2012 13:56:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: fix compilation warning
Message-ID: <20121203105609.GE6568@mwanda>
References: <1354530848-12516-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354530848-12516-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:34:08AM +0000, Cong Ding wrote:
> We do not allow old-style function definition.  Always spell foo(void) if
> a function does not take any parameters.
> 

You should be working against linux-next.  This driver has been
deleted in linux-next.

The subject should have been:
[PATCH] Staging: telephony/ixj: fix sparse warning
or something like that.  "drivers" is not useful.  And Staging by
itself is too broad.

I think it's a Sparse warning, not a compile warning?  Copy and
paste the warning into the commit message.

Anyway, since this was deleted it doesn't matter.

regards,
dan carpenter

