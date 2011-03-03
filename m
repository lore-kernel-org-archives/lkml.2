Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab1CCCRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:17:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757725Ab1CCCRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:17:20 -0500
Date: Wed, 2 Mar 2011 18:17:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-03-02-16-52 uploaded
Message-Id: <20110302181711.2399cdba.akpm@linux-foundation.org>
In-Reply-To: <20110303130538.3e99f952.sfr@canb.auug.org.au>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
	<20110303130538.3e99f952.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 13:05:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 02 Mar 2011 16:52:55 -0800 akpm@linux-foundation.org wrote:
> >
> > The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> If you create your linux-next.patch using kapm-start..kapm-end in the
> linux-next tree, you will save about 8000+ lines of patch and you won't
> need "next-remove-localversion.patch" any more.  I am keeping those
> references up to date each day.

What's in the 8000 lines?

> BTW, To keep "git am" happy:
> 
> diff --git a/broken-out/memcg-keep-only-one-charge-cancelling-function-fix.patch
> index e081c43..42c45fc 100644
> --- a/broken-out/memcg-keep-only-one-charge-cancelling-function-fix.patch
> +++ b/broken-out/memcg-keep-only-one-charge-cancelling-function-fix.patch
> @@ -1,3 +1,4 @@
> +From: Johannes Weiner <hannes@cmpxchg.org>
>  
>  Keep the underscore-version of the charge cancelling function which took a
>  page count, rather than silently changing the semantics of the
> 

Didn't understand that - why is git-am unhappy?  Your sentence was
truncated.
