Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0IJLL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:11:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33493 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab0IJLLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:11:55 -0400
Date: Fri, 10 Sep 2010 13:11:53 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910131153.56419f17@schatten.dmk.lab>
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

Btw, why? I think it is a great way to show that it was done in an
automated fashion. 

I wondered if tagging another way would be useful but thought the
role:what could be used to allow better filtering on the receiving
side. 

It also would show how many people used get_maintainer.pl. 

Maybe some people want to suppress the name-tagging via a cmdline, but
then I think the tagging should be default on or it could backpack on
the --git/--nogit option. 

Cheers,
Flo
