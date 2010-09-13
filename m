Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0IMVRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:17:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1960 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab0IMVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:17:22 -0400
Subject: Re: [PATCH 18/25] drivers/serial/suncore.c: Use static const char
 arrays
From: Joe Perches <joe@perches.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
In-Reply-To: <20100913211106.GA4200@elliptictech.com>
References: <cover.1284406638.git.joe@perches.com>
	 <0ab674aa32a5fcc364982c78efdf44864a61523b.1284406639.git.joe@perches.com>
	 <20100913213613.223e10a5@lxorguk.ukuu.org.uk>
	 <1284409338.26719.47.camel@Joe-Laptop>
	 <20100913211106.GA4200@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 14:17:20 -0700
Message-ID: <1284412640.26719.95.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:11 -0400, Nick Bowler wrote:
> On 2010-09-13 13:22 -0700, Joe Perches wrote:
> > It tries to standardize the style use and it avoids possible
> > future checkpatch warnings of:
> > 	char foo[] = "bar"
> > char array could possibly be static const.
> Whoa, back up a second here.  I've seen patches to avoid questionable
> checkpatch warnings before, but I think this is the first time I've seen
> a patch to avoid *hypothetical checkpatch warnings that don't even
> exist*!

Pretty cool huh?  cheers, Joe

