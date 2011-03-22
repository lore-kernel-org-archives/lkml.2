Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1CVDvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:51:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1CVDvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:51:50 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=3tv-XyP8b2UA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=aIZmXXnTiiUW2bCOL3IA:9 a=aqoT7wxkPt8UuKi77b1IbTNewcAA:4 a=CjuIK1q_8ugA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 21 Mar 2011 23:51:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
        rdunlap@xenotime.net, joe@perches.com
Subject: Re: [RFC]A question about kernel's development
Message-ID: <20110322035148.GM14675@home.goodmis.org>
References: <20110322033312.GA2219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322033312.GA2219@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:33:14AM +0800, Harry Wei wrote:
> Hi us,
>    I wanna know our kernel's development 
> procedure for details. I just realize
> when we get a stable release, we must 
> merge trementous patches into kernel.
> I often watch -rc kernels, -git kernels, 
> , -mm kernels and know their promulgators.
> But i don't know their relationships and
> sequences for shaping stable ones.

Well, a quick answer is that when we fix a bug, we tag it with
 Cc: stable@kernel.org

Then when it is applied to Linus's tree, Greg then can choose to pull it
into the stable branch.

I also believe that Greg spends lots of lonely nights looking into git
commits, drinking his favorite Latte and cursing at all the git patches
that fix a bug that didn't have a Cc: stable tag attached. He use to
have a huge mane of hair on his head before taking over as stable
maintainer ;)

-- Steve

>    Okay, now we want to develop 2.6.38 
> to 2.6.39. How many specific steps should we
> do? In fact, i recognize some. But i want to 
> understand all the concrete procedures. Could
> anyone help me, thanks in advance.
