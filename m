Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1H2Ncr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:32:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:35488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1H2Ncl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:32:41 -0400
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
From: Peter Zijlstra <peterz@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Date: Mon, 29 Aug 2011 15:32:32 +0200
In-Reply-To: <4E580830.4010305@panasas.com>
References: <4E56CE8F.8080501@panasas.com>
	 <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
	 <4E580830.4010305@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314624752.2816.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 13:55 -0700, Boaz Harrosh wrote:

> But this patch is for all the people and distributions that are going
> to use the old git versions for a while, (Years).
> 
> It is important for the Linux mailing-list review, because you get
> patches with:
> 
> @@@ lable out:
> -	change foo
> +	to bazz
> 
> And how the hell are you suppose to know where in the file it is.
> This is such a trivial addition, that can help unify everyone's
> usage. I don't see the down sides.

Ah, I'm using:

# cat ~/.gitconfig 
[diff "default"]
                xfuncname = "^[[:alpha:]$_].*[^:]$"


For this.
