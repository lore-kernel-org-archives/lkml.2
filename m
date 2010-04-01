Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab0DABjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:39:07 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:43677 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758596Ab0DABjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:39:04 -0400
Date: Thu, 1 Apr 2010 09:38:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>, steffen.klassert@secunet.com,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100401013845.GA19580@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de> <20100329081550.GA22334@gondor.apana.org.au> <20100331145817.bd0a1a08.akpm@linux-foundation.org> <20100401002440.GB18893@gondor.apana.org.au> <20100331180445.98dbcb55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331180445.98dbcb55.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 06:04:45PM -0400, Andrew Morton wrote:
>
> I can find it once, in December 2009, in the middle of a massive thread
> called "workqueue thing".  It had no replies.

OK you're right.  It's only been posted to lkml once.  However,
this has been discussed on netdev since 2008 at least.  The patch
in its current form has also been acked by David Miller.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
