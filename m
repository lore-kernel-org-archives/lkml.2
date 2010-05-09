Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab0EIIkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:40:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48490 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab0EIIkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:40:45 -0400
Date: Sun, 9 May 2010 10:40:41 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by
 default
Message-ID: <20100509104041.1186d5f1@schatten.dmk.lab>
In-Reply-To: <1273358674.704.77.camel@Joe-Laptop.home>
References: <1273354364-6016-1-git-send-email-florian@mickler.org>
	<1273354778-6129-1-git-send-email-florian@mickler.org>
	<1273358674.704.77.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 May 2010 15:44:34 -0700
Joe Perches <joe@perches.com> wrote:

> On Sat, 2010-05-08 at 23:39 +0200, florian@mickler.org wrote:
> > If scm meta-information is used, only list people that signed-off or
> > acked or reviewed the code in question.
> > 
> > after all it's called get_maintainer.pl and not
> > get_random_people_to_look_at_the_code.pl
> 
> Anyone that actually signs a patch is not "random".
> 

I actually think that tested-by and reviewed-by is not "signing",
because it is not the person who does the "tag insertion". 

it was one of the signed-off-by's who put the reviewed- and testet-tags
in there. presumably this is done in agreement with the mentioned
person. 

And for facts, please check this out:

$ git log --since=1-year-ago | grep -Pi "(reported|tested)-by:.*@"  \
 | cut -f2- -d":" | sort | uniq | wc -l
1280

so i would say, these numbers (combied with your top ten which
accounts for only 318 signatures ) suggest that those mentioned with
these tag's are one-off bug reporters and not maintainers.

cheers,
Flo
