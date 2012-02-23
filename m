Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2BWW6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:58:34 -0500
Received: from ist.d-labs.de ([213.239.218.44]:57113 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab2BWW6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:58:33 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 17:58:33 EST
Date: Thu, 23 Feb 2012 23:52:13 +0100
From: Florian Mickler <florian@mickler.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Miller <davem@davemloft.net>, davej@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression tracking
Message-ID: <20120223235213.37735af8@schatten>
In-Reply-To: <201201230152.25575.rjw@sisk.pl>
References: <201201222031.51116.maciej.rutecki@gmail.com>
	<201201222052.02135.maciej.rutecki@gmail.com>
	<20120122.150707.1411449164435920150.davem@davemloft.net>
	<201201230152.25575.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 01:52:25 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, January 22, 2012, David Miller wrote:
> > From: Maciej Rutecki <maciej.rutecki@gmail.com>
> > Date: Sun, 22 Jan 2012 20:52:02 +0100
> > 
> > > OK. But tracking regressions in two (or more) places is nonsense. And this 
> > > puts into question all of my current work, such as how to analyze 
> > > (automatically) the progress of the whole kernel and its quality per each -rc. 
> > > Problem to discussion, but if everyone will do as you wish, it will all work 
> > > went to waste.
> > 
> > If someone else wants to maintain the state of bugs on some web
> > site and click buttons all day long, that is their perogative.
> > 
> > But it's not something I'm going to do.
> > 
> > You can't force people to use tools, and frankly that's the end of
> > this conversation as far as I'm concerned.

What I would like to ask from you and other developers in order to make
life easier for all users reporting bugs and people tracking
regressions is to post a solution for an issue to the mail thread it
was first reported in. That way we can just read through that mail
thread and see that it is resolved.

Also if you are aware, that someone (Maciej!) did open a bug for an
issue, please(!) stick that number in the commit changelog. Full Url
would be wonderful for automated processing, but "bug [nr]" is
sufficient for manual scanning of the commit log. 


If you don't do that, I fear that I will annoy you from time to time
with: "is this issue fixed already?" or "hey, what about that 4 month
old regression? Is it already fixed?". (And knowing netdev, it is of
course already fixed in 99.9% of the cases. So I just need the pointer
to the solution...)

[If I have much time at hand, I will even scan the mail chatter of the
people involved during the time frame the bug was reported, but that is
a tedious task... still I do that sometimes in order to avoid annoying
people with this silly stuff]

Regards,
Flo
