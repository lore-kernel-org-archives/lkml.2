Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1CQDHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:07:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41077 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1CQDHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:07:23 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=t2cZ8YHimCQA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=PlLt6J11XkwTgK0pGicA:9 a=xxZdxPc0zBEiOrX-C2QA:7 a=TNr8WG__okfQwzIF2LnEtBRf-msA:4 a=CjuIK1q_8ugA:10 a=JTMqrY5UvyEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 16 Mar 2011 23:07:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Total BKL removal, finally
Message-ID: <20110317030720.GB14675@home.goodmis.org>
References: <201103162239.37299.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103162239.37299.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:39:37PM +0100, Arnd Bergmann wrote:
> commit 4ba8216cd90560bc402f52076f64d8546e8aefcb
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Tue Jan 25 22:52:22 2011 +0100
> 
>     BKL: That's all, folks

All I can say is "Yay!"

Nice work Arnd.

-- Steve

>     
>     This removes the implementation of the big kernel lock,
>     at last. A lot of people have worked on this in the
>     past, I so the credit for this patch should be with
>     everyone who participated in the hunt.
>     
>     The names on the Cc list are the people that were the
>     most active in this, according to the recorded git
>     history, in alphabetical order.
>     
