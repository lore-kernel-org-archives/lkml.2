Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab0I0O5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:57:52 -0400
Received: from ist.d-labs.de ([213.239.218.44]:45854 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab0I0O5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:57:51 -0400
Date: Mon, 27 Sep 2010 16:57:48 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100927165748.354742f2@schatten.dmk.lab>
In-Reply-To: <1285527125.1732.24.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1285527125.1732.24.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010 11:52:05 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-09-10 at 11:33 +0200, florian@mickler.org wrote:
> > The script get_maintainer.pl is a very useful tool for deploying changes
> > made to the kernel. Among others it searches not only the MAINTAINERS
> > file but also the git history for people to send patches to.
> > 
> > This can be unexpected for the receiving side and can and does provoke
> > sometimes anger because it is not easy to determine if the sender did
> > explicitly put the receiving side on the cc list, or if they just
> > trolled the tree. The receiving side, if not used to be cc'd on many
> > things will check the patch, spend time investigating what the heck they
> > were cc'd just to realize, that there was no special reason.
> > 
> > As get_maintainer.pl is frequently used by kernel newcomers who _can_
> > not know whom to cc by themself, this anger then comes as a surprise for them
> > and definitely puts them in an awkward position.
> > 
> > By appending a  a note of the reason for the cc in the name, the reason
> > becomes clear and the receiving side is relieved from feeling obliged to
> > check the patch  while the sending side has a chance to adapt the
> > cc'list to their liking.
> > 
> > But the most useful aspect of this is, IMHO, that it makes it transparent who
> > just used get_maintainer.pl as a shortcut to increase his own
> > patch-throughput or who really put an effort in finding or editing the
> > cc'list to their likings.
> 
> How about making --rolestats the default and adding a --nodecorate
> option default off?
> 
> This would mean that any current script that expects bare email
> addresses would need to add --nodecorate to get the old behavior.
> 

Would in essence have the same effect, but I think it's slightly better
to have some shorter tags in the mail addresses, as I expect them to
actually show up on lkml quite a bit.

Regards,
Flo
