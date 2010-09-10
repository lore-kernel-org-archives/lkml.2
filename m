Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0IJPMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:12:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1640 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab0IJPMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:12:39 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100910131153.56419f17@schatten.dmk.lab>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910131153.56419f17@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 08:12:37 -0700
Message-ID: <1284131557.1783.150.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 13:11 +0200, Florian Mickler wrote:
> On Fri, 10 Sep 2010 02:42:47 -0700
> Joe Perches <joe@perches.com> wrote:
> > On Fri, 2010-09-10 at 11:33 +0200, florian@mickler.org wrote:
> > > The script get_maintainer.pl is a very useful tool for deploying changes
> > > made to the kernel. Among others it searches not only the MAINTAINERS
> > > file but also the git history for people to send patches to.\
> > []
> > > By appending a  a note of the reason for the cc in the name, the reason
> > > becomes clear and the receiving side is relieved from feeling obliged to
> > > check the patch  while the sending side has a chance to adapt the
> > > cc'list to their liking.
> > I don't like reading annotated email names myself.
> Btw, why? I think it is a great way to show that it was done in an
> automated fashion. 

More stuff than necessary to read, requires effort to find next.
Fewer names in visual field.

Also, it can affect systems that automatically add email addresses
to an address directory as it could store the entire content
before the < as the name.


