Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2HNCVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:21:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38727 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912Ab2HNCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:21:50 -0400
X-Sasl-enc: ourTm9FweBOgXxutMt7XdN2dRHGBhLPWhLx+YKi3ReRe 1344910909
Date: Mon, 13 Aug 2012 19:21:48 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/olpc_dcon: fix checkpatch warnings
Message-ID: <20120814022148.GA8874@kroah.com>
References: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
 <1343389552-14684-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343389552-14684-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 08:45:52PM +0900, Toshiaki Yamane wrote:
> fixed some checkpatch warnings.
> (Excluding -WARNING: msleep < 20ms can sleep for up to 20ms-)

Then fix your changelog entry:

> 
> $ find drivers/staging/olpc_dcon/ -name "*.[ch]"|xargs ./scripts/checkpatch.pl \
> -f --terse --nosummary|cut -f3- -d":"|sort |uniq -c|sort -n
>       2  WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt

That shouldn't be there.

greg k-h
