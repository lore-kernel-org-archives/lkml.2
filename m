Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab0IKJeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:34:08 -0400
Received: from ist.d-labs.de ([213.239.218.44]:38980 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0IKJeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:34:06 -0400
Date: Sat, 11 Sep 2010 11:34:03 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100911113403.17003faf@schatten.dmk.lab>
In-Reply-To: <1284131557.1783.150.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910131153.56419f17@schatten.dmk.lab>
	<1284131557.1783.150.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 08:12:37 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-09-10 at 13:11 +0200, Florian Mickler wrote:
> > On Fri, 10 Sep 2010 02:42:47 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > On Fri, 2010-09-10 at 11:33 +0200, florian@mickler.org wrote:
> > > > The script get_maintainer.pl is a very useful tool for deploying changes
> > > > made to the kernel. Among others it searches not only the MAINTAINERS
> > > > file but also the git history for people to send patches to.\
> > > []
> > > > By appending a  a note of the reason for the cc in the name, the reason
> > > > becomes clear and the receiving side is relieved from feeling obliged to
> > > > check the patch  while the sending side has a chance to adapt the
> > > > cc'list to their liking.
> > > I don't like reading annotated email names myself.
> > Btw, why? I think it is a great way to show that it was done in an
> > automated fashion. 
> 
> More stuff than necessary to read, requires effort to find next. 

next what? 

I think the normal case is to ignore the name tag. It is only if you
really get many many emails that you will begin to filter for these
role-tags. And then you will probably do it in an automated fashion.



> Fewer names in visual field.

ok. But anybody who cares about his patch submission deeply can edit
the cc'list before sending. And then he is also likely to trim the
cc'list by leaving out people that did only trivial spelling fixes or
renamed stuff, or flamed them the last time.


> 
> Also, it can affect systems that automatically add email addresses
> to an address directory as it could store the entire content
> before the < as the name.

I think any system that relies on input it can not control has to deal
with these kind of stuff anyway. (Be it typo's or just plain wrong
names, or surename<->name switcheroos...)
So I don't think this is that big a concern.


Cheers,
Flo
