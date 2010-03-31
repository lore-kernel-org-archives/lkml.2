Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab0DABG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:06:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758137Ab0DABG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:06:56 -0400
Date: Wed, 31 Mar 2010 18:04:45 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>, steffen.klassert@secunet.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-Id: <20100331180445.98dbcb55.akpm@linux-foundation.org>
In-Reply-To: <20100401002440.GB18893@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
	<20100329081550.GA22334@gondor.apana.org.au>
	<20100331145817.bd0a1a08.akpm@linux-foundation.org>
	<20100401002440.GB18893@gondor.apana.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 08:24:40 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 31, 2010 at 02:58:17PM -0700, Andrew Morton wrote:
> >
> > (wtf?)
> > 
> > OK, on behalf of thousands I ask: what the heck is kernel/padata.c? 
> > 
> > Seems to have popped up in 2.6.34, positioned as generic kernel-wide
> > code only it has been secreted away on the linux-crypto list.  Please
> > don't do this.
> 
> It was posted to linux-kernel multiple times.
> 

I can find it once, in December 2009, in the middle of a massive thread
called "workqueue thing".  It had no replies.

