Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0EIItY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:49:24 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43265 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0EIItW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:49:22 -0400
Date: Sun, 9 May 2010 10:49:19 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by
 default
Message-ID: <20100509104919.3ec3e9ba@schatten.dmk.lab>
In-Reply-To: <1273366633.704.109.camel@Joe-Laptop.home>
References: <1273354364-6016-1-git-send-email-florian@mickler.org>
	<1273354778-6129-1-git-send-email-florian@mickler.org>
	<1273358674.704.77.camel@Joe-Laptop.home>
	<4BE5F286.1020503@s5r6.in-berlin.de>
	<1273362666.704.104.camel@Joe-Laptop.home>
	<4BE60045.3040600@s5r6.in-berlin.de>
	<1273366633.704.109.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 May 2010 17:57:13 -0700
Joe Perches <joe@perches.com> wrote:

> On Sun, 2010-05-09 at 02:22 +0200, Stefan Richter wrote:
> > But how does this indicate a need to include these addresses into
> > get_maintainer.pl output?  In no way at all.
> 
> Supporting stats please.

#number of one-off tested-by/reported-by appearences
git log --since=1-year-ago | grep -Pi "(reported|tested)-by:.*@"   | cut -f2- -d":" | sort | uniq -c  | awk '{print $1}' | grep '^1$' | wc -l
822

cheers,
Flo

p.s.: please double check the cmdline, but i think this is correct.
