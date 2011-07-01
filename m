Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab1GAEED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 00:04:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3410 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1GAEEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:04:01 -0400
Subject: Re: [PATCH 0/2] netpoll: Trivial updates
From: Joe Perches <joe@perches.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4E0D4651.7000005@redhat.com>
References: <cover.1309482314.git.joe@perches.com>
	 <4E0D3E80.5080209@redhat.com> <1309491349.7277.22.camel@Joe-Laptop>
	 <4E0D43C3.5090502@redhat.com> <1309492522.7277.25.camel@Joe-Laptop>
	 <4E0D4651.7000005@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 21:03:59 -0700
Message-ID: <1309493039.7277.26.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 12:00 +0800, Cong Wang wrote:
> 于 2011年07月01日 11:55, Joe Perches 写道:
> > On Fri, 2011-07-01 at 11:49 +0800, Cong Wang wrote:
> >> 于 2011年07月01日 11:35, Joe Perches 写道:
> >>>> BTW, you can kill the export of netpoll_send_skb_on_dev() too.
> >>> Not too sure about that.
> >>> It's used in netpoll.h by netpoll_send_skb.
> >>> It could be called from anywhere.
> >>> It's currently called/used by bonding.h.
> > Read what I wrote.
> > Look up one level at where it's used by netpoll.h.
> Then move netpoll_send_skb(), export it instead of netpoll_send_skb_on_dev()...

Submit that if you choose.


