Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab0IJKan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:30:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53845 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0IJKam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:30:42 -0400
Date: Fri, 10 Sep 2010 12:30:40 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910123040.5a6f0128@schatten.dmk.lab>
In-Reply-To: <1284111767.1783.35.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 02:42:47 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-09-10 at 11:33 +0200, florian@mickler.org wrote:
> > The script get_maintainer.pl is a very useful tool for deploying changes
> > made to the kernel. Among others it searches not only the MAINTAINERS
> > file but also the git history for people to send patches to.\
> []
> > By appending a  a note of the reason for the cc in the name, the reason
> > becomes clear and the receiving side is relieved from feeling obliged to
> > check the patch  while the sending side has a chance to adapt the
> > cc'list to their liking.
> 
> I don't like reading annotated email names myself.
> 
> As the coverage of file patterns in MAINTAINERS is
> now pretty good, the --git results are less useful.
> 
> I'd much rather turn off --git as a default, or change
> get_maintainers to add git signers only when there's no
> specifically listed maintainer for a particular file.
> 
> 

Of course, that is also an option. 

But I personally would love to be cc'd on files I committed stuff to,
as long as it is clear, that it was done in an automated way. 

People that get angered by being cc'd a lot as commit_signers can always
filter their mail for that. 
But I don't think it is the major part of kernel hackers that get angry
when they are cc'd. Most kernel hackers _love_ getting mail, or not? :) 
At least they should.

Your mileage may vary of course, but I can't see any harm done by this
change. Anyone familiar with get_maintainer.pl can always just put
"--nogit" in his .get_maintainer.conf file. 

I think the --git thing is great, as it really get's patches into the
kernel vs letting them rot on some mailinglist.

But  
Cheers,
Flo
