Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab0DARCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758576Ab0DARBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:01:55 -0400
Date: Thu, 1 Apr 2010 09:59:00 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, henne@nachtwindheim.de,
       steffen.klassert@secunet.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-Id: <20100401095900.169b4d00.akpm@linux-foundation.org>
In-Reply-To: <20100401.001556.24588152.davem@davemloft.net>
References: <20100331180445.98dbcb55.akpm@linux-foundation.org>
	<20100401013845.GA19580@gondor.apana.org.au>
	<20100331202931.146ef1b5.akpm@linux-foundation.org>
	<20100401.001556.24588152.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Apr 2010 00:15:56 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 31 Mar 2010 20:29:31 -0400
> 
> > Thing is, this isn't net code and it isn't crypto code - it's a
> > kernel-wide utility.
> 
> Thanks goodness, because if we had put a private copy in the
> networking or the crypto code someone would have given us a hard time.
> 
> Wait a second... we're being given a hard time anyways. :-)

Because the target audience for this work weren't informed about it,
and it would have been better if they had been.

> Kidding aside, why didn't anyone show any interest in the patch when
> it was posted to lkml?  You can say it was smoothered together with
> some crypto stuff, but that was absolutely the logical thing to do
> because the follow-on crypto patches showed what the thing was going
> to be used for.

I dunno - these things happen.  The padata patch appears to have been
sent once to netdev as an RFC back in 2008 and didn't get any replies
there either.  Personally I pay less attention to patches which appear
in the middle of some discussion because I assume they're for
discussion purposes and will come back later.

If I'd known this code was coming I would have reviewed it at an
appropriate time.  Probably others are interested also.
