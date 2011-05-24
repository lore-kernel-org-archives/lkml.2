Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1EXECf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:02:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324Ab1EXECd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au> <BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 21:01:39 -0700
Message-ID: <BANLkTine2kobQA8TkmtiuXdKL=07NCo2vA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 7:06 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>
> more failures:

Is this blackfin or something?

I did an allyesconfig with a special x86 patch that should have caught
everything that didn't have the proper prefetch.h include, but non-x86
drivers would have passed that.

And I guess I didn't do my "force staging drivers on" hack for that test either.

                      Linus
