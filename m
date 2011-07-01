Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1GADfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:35:51 -0400
Received: from mail.perches.com ([173.55.12.10]:3405 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab1GADfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:35:50 -0400
Subject: Re: [PATCH 0/2] netpoll: Trivial updates
From: Joe Perches <joe@perches.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4E0D3E80.5080209@redhat.com>
References: <cover.1309482314.git.joe@perches.com>
	 <4E0D3E80.5080209@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 20:35:49 -0700
Message-ID: <1309491349.7277.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 11:26 +0800, Cong Wang wrote:
> 于 2011年07月01日 09:08, Joe Perches 写道:
> > cc: WANG Cong<amwang@redhat.com>
> > Joe Perches (2):
> >    netpoll: Remove unused EXPORT_SYMBOLs of netpoll_poll and netpoll_poll_dev
> >    netpoll: Remove trivial wrapper function netpoll_poll
> >   include/linux/netpoll.h |    2 --
> >   net/core/netpoll.c      |   13 +++----------
> >   2 files changed, 3 insertions(+), 12 deletions(-)
> I am fine with patch 1/2, but not 2/2, since it is trivial,
> why touch it? With netpoll_poll(), we don't need to explore the
> details of struct netpoll, I think it is nice to have it.

Shrug.  Neither is used.  Keep things minimal.

> BTW, you can kill the export of netpoll_send_skb_on_dev() too.

Not too sure about that.

It's used in netpoll.h by netpoll_send_skb.
It could be called from anywhere.
It's currently called/used by bonding.h.

cheers, Joe



