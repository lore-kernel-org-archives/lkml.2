Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab0DADbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:31:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0DADbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:31:34 -0400
Date: Wed, 31 Mar 2010 20:29:31 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>, steffen.klassert@secunet.com,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] padata: section cleanup
Message-Id: <20100331202931.146ef1b5.akpm@linux-foundation.org>
In-Reply-To: <20100401013845.GA19580@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
	<20100329081550.GA22334@gondor.apana.org.au>
	<20100331145817.bd0a1a08.akpm@linux-foundation.org>
	<20100401002440.GB18893@gondor.apana.org.au>
	<20100331180445.98dbcb55.akpm@linux-foundation.org>
	<20100401013845.GA19580@gondor.apana.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 09:38:45 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 31, 2010 at 06:04:45PM -0400, Andrew Morton wrote:
> >
> > I can find it once, in December 2009, in the middle of a massive thread
> > called "workqueue thing".  It had no replies.
> 
> OK you're right.  It's only been posted to lkml once.  However,
> this has been discussed on netdev since 2008 at least.  The patch
> in its current form has also been acked by David Miller.
> 

Thing is, this isn't net code and it isn't crypto code - it's a
kernel-wide utility.  Everyone needs to know at least a bit about it
and code-reviewers such as myself need to know a lot about it, so we
can tell people "hey dummy, shouldn't you use padata".

So please, can we belatedly go through the process of educating the
developers about this thing you guys have written for us?

