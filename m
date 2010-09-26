Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0IZSwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:52:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2448 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab0IZSwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:52:07 -0400
Subject: RFC: get_maintainer.pl: append reason for cc to the name by default
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>, Florian Mickler <florian@mickler.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1284111212-10659-1-git-send-email-florian@mickler.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Sep 2010 11:52:05 -0700
Message-ID: <1285527125.1732.24.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 11:33 +0200, florian@mickler.org wrote:
> The script get_maintainer.pl is a very useful tool for deploying changes
> made to the kernel. Among others it searches not only the MAINTAINERS
> file but also the git history for people to send patches to.
> 
> This can be unexpected for the receiving side and can and does provoke
> sometimes anger because it is not easy to determine if the sender did
> explicitly put the receiving side on the cc list, or if they just
> trolled the tree. The receiving side, if not used to be cc'd on many
> things will check the patch, spend time investigating what the heck they
> were cc'd just to realize, that there was no special reason.
> 
> As get_maintainer.pl is frequently used by kernel newcomers who _can_
> not know whom to cc by themself, this anger then comes as a surprise for them
> and definitely puts them in an awkward position.
> 
> By appending a  a note of the reason for the cc in the name, the reason
> becomes clear and the receiving side is relieved from feeling obliged to
> check the patch  while the sending side has a chance to adapt the
> cc'list to their liking.
> 
> But the most useful aspect of this is, IMHO, that it makes it transparent who
> just used get_maintainer.pl as a shortcut to increase his own
> patch-throughput or who really put an effort in finding or editing the
> cc'list to their likings.

How about making --rolestats the default and adding a --nodecorate
option default off?

This would mean that any current script that expects bare email
addresses would need to add --nodecorate to get the old behavior.

