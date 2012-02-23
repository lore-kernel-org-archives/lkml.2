Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2BWXWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:22:20 -0500
Received: from ist.d-labs.de ([213.239.218.44]:49234 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab2BWXWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:22:16 -0500
Date: Fri, 24 Feb 2012 00:22:10 +0100
From: Florian Mickler <florian@mickler.org>
To: Dave Jones <davej@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression tracking
Message-ID: <20120224002210.0f59ff53@schatten>
In-Reply-To: <20120223230531.GA6589@redhat.com>
References: <201201222031.51116.maciej.rutecki@gmail.com>
	<201201222052.02135.maciej.rutecki@gmail.com>
	<20120122.150707.1411449164435920150.davem@davemloft.net>
	<201201230152.25575.rjw@sisk.pl>
	<20120223235213.37735af8@schatten>
	<20120223230531.GA6589@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 18:05:32 -0500
Dave Jones <davej@redhat.com> wrote:

> On Thu, Feb 23, 2012 at 11:52:13PM +0100, Florian Mickler wrote:
> 
>  > If you don't do that, I fear that I will annoy you from time to time
>  > with: "is this issue fixed already?" or "hey, what about that 4 month
>  > old regression? Is it already fixed?".
> 
> If you intend to do this, please add me to your "do not mail" list.
> 
> For people working at distributions acting as middle-man, this isn't
> helpful at all. And it's just not feasible for me to go dig out every
> thread I posted to just to reply with "fixed".
> 
> 	Dave
> 

You are not on my go-to-guy list since you do not maintain a kernel
subsystem and I don't expect you to keep track of anything. If you post
a link to a rh-bugzilla, I will of course check if that one is still
open or how it is closed. I'm not stupid, I just need some
silver linen threads to find how a regression is solved.

I.e. I don't want a "fixed". I want a "commit xyz fixed this"
or a "I can't reproduce the bug anymore". Either is fine. 
