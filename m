Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031815Ab2K3VOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:14:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42712 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031518Ab2K3VOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:14:41 -0500
Date: Fri, 30 Nov 2012 13:14:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
Message-ID: <20121130211435.GJ3873@htj.dyndns.org>
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
 <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Anders.

Sorry about the delay.

On Wed, Nov 28, 2012 at 10:17:28AM -0500, Anders Kaseorg wrote:
> On Wed, 28 Nov 2012, Anders Kaseorg wrote:
> > My Intel 6250 wireless card (iwldvm) can no longer associate with a 
> > WPA-Enterprise network (PEAP-MSCHAPv2).  To my surprise, I bisected this 
> > regression to commit e7c2f967445dd2041f0f8e3179cca22bb8bb7f79, 
> > workqueue: use mod_delayed_work() instead of __cancel + queue.

I see.

> > A bunch of logs collected by Ubuntu apport are in this bug report: 
> >   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1083980
> > 
> > How can I help to debug this?
> > 
> > I see that someone else reported another regression with the same commit 
> > last week, although this looks unrelated at first glance: 
> >   http://thread.gmane.org/gmane.linux.kernel/1395938

Urgh... that one was in my spam folder probably due to the mimed
content.  Nothing rings a bell yet.  Will keep looking into it.

Thanks.

-- 
tejun
