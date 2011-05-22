Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1EVTbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:31:09 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:44245 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1EVTbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:31:05 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20110521235408.GK2271@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <1306016630.2066.44.camel@x61.thuisdomein>
	 <20110521235408.GK2271@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 21:30:57 +0200
Message-ID: <1306092657.2066.53.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 16:54 -0700, Paul E. McKenney wrote:
> On Sun, May 22, 2011 at 12:23:50AM +0200, Paul Bolle wrote: 
> > Is anyone able to spot one or more commits in v2.6.39-rc7..v2.6.39 that
> > might have fixed this Oops? Or did my chance of hitting this Oops,
> > somehow, just got a lot smaller in v.2.6.39?

As I just discovered, Fedora Rawhide ships release candidates configured
with a lot more debugging options set than it ships final releases. So,
sadly, this didn't get fixed in v2.6.39. It just didn't show up because
one or more configuration options weren't set while they used to be set
in the preceding release candidates kernels.

> 5f45c69589b7d ("read_lock() does not always imply rcu_read_lock()") might
> well be a fix.

It doesn't really matter anymore, but that one was actually already
included in v2.6.39-rc5.


Paul Bolle

