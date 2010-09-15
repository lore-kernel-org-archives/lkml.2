Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0IOMt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:49:57 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58193 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0IOMt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:49:56 -0400
Date: Wed, 15 Sep 2010 14:49:53 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100915144953.3a86c0a4@schatten.dmk.lab>
In-Reply-To: <1284525949.26719.153.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100911001350.GA11478@infradead.org>
	<1284165074.1783.213.camel@Joe-Laptop>
	<20100911004550.GA30584@infradead.org>
	<20100911112855.6ee6e929@schatten.dmk.lab>
	<m1hbhucdv5.fsf@fess.ebiederm.org>
	<1284364665.22185.116.camel@Joe-Laptop>
	<20100913105434.62b150f7@schatten.dmk.lab>
	<m1lj749ra2.fsf@fess.ebiederm.org>
	<20100914194646.52d4bf96@schatten.dmk.lab>
	<1284521324.26719.146.camel@Joe-Laptop>
	<20100915063445.7d8ccd4d@schatten.dmk.lab>
	<1284525949.26719.153.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 21:45:49 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2010-09-15 at 06:34 +0200, Florian Mickler wrote:
> > But for the interactive mode I had STDIN in mind. 
> > And now that I checked, it is indeed possible. I have a quick prove of
> > concept for an get_maintainer.pl --interactive mode that shows you the
> > cc's, lists their commits  and let's you choose whom to add to the cc
> > (using STDERR, as git-send-email.pl obviously expects adresses on
> > STDOUT).
> > I haven't experimented much with it, but if it works out expect a
> > patch. But first I need some coffee and breakfast, as it's morning
> > over here. :-)
> 
> I suggest you don't need to patch get_maintainer.pl,
> but should add another script that calls it and/or
> uses git commands directly.
> 
> cheers, Joe
> 
> 

Have a look at the patch I sent seperately to lkml. 
I think it integrates well.

Regards,
Flo
