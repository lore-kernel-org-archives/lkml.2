Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2LCLEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:04:34 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59653 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2LCLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:04:33 -0500
Date: Mon, 3 Dec 2012 11:04:29 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: fix compilation warning
Message-ID: <20121203110428.GA22681@gmail.com>
References: <1354530848-12516-1-git-send-email-dinggnu@gmail.com>
 <20121203105609.GE6568@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203105609.GE6568@mwanda>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 01:56:09PM +0300, Dan Carpenter wrote:
> On Mon, Dec 03, 2012 at 10:34:08AM +0000, Cong Ding wrote:
> > We do not allow old-style function definition.  Always spell foo(void) if
> > a function does not take any parameters.
> > 
> 
> You should be working against linux-next.  This driver has been
> deleted in linux-next.
> 
> The subject should have been:
> [PATCH] Staging: telephony/ixj: fix sparse warning
> or something like that.  "drivers" is not useful.  And Staging by
> itself is too broad.
> 
> I think it's a Sparse warning, not a compile warning?  Copy and
> paste the warning into the commit message.
sure, thanks for the suggestions. 

- cong

> 
> Anyway, since this was deleted it doesn't matter.
> 
> regards,
> dan carpenter
> 
