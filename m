Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab1EaUNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:13:54 -0400
Received: from 1wt.eu ([62.212.114.60]:36544 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab1EaUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:13:53 -0400
Date: Tue, 31 May 2011 22:13:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Joe Pranevich <jpranevich@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0 change listings - Wonderful World of Linux 3.0
Message-ID: <20110531201348.GA8723@1wt.eu>
References: <BANLkTikvU-XUu9sWX-E87a7CUtA7j+ZRpA@mail.gmail.com> <BANLkTi=w7VhV2GxKrGGe9dirHcEkwKrDwA@mail.gmail.com> <BANLkTim7XZKLCRp=ZtRJWhi7k4BzwYpRpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim7XZKLCRp=ZtRJWhi7k4BzwYpRpg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 01:22:49AM -0400, Joe Pranevich wrote:
> Mike,
> 
> Thank you. I appreciate the comments and the corrections. It was a
> marathon weekend and yes, I missed some obvious typos. Thanks.
> 
> As far as what is supported and when, my rule has been that if it is
> labeled as "experimental", then it isn't released. So, that accounts
> for why I didn't list NFSd v4 in this doc, even though there is a
> module for it. (I should make this more clear though.) Similarly, I
> *do* list IPv6 as new. It was listed as experimental in v2.6.0, so
> that qualifies it for inclusion here.

Many things have been marked experimental for years and remained like
this just because nobody cared to change the comment in the Kconfig
or config.in. But Mike is right :

willy@fw:willy$ ip -6 a s dev eth0
3: eth0: <BROADCAST,MULTICAST,UP> qlen 1000
    inet6 2001:7a8:363c::1/64 scope global 
    inet6 fe80::280:c8ff:feca:d2b9/64 scope link 
willy@fw:willy$ uname -a
Linux fw 2.4.37-wt3-fw #1 Sun Jan 31 00:55:16 CET 2010 i686 unknown unknown GNU/Linux
willy@fw:willy$ 

And this machine was installed with something like 2.4.22 ten years ago.
It's quite awkward to announce as "new" something that has been running
in production at many places for ten years. It will sensibly discredit
your article.

I'd say that in general, almost all of the features you're announcing as
"new" will make unaware people think that older versions did not have
those features, which is quite misleading. Linus took great care to say
that 3.0-rc1 had very few changes, it can be a bit confusing to see a
post pretending it to be a revolutionary new kernel.

Probably that you should more clearly say that all those features were
progressively added in all 2.6 releases, otherwise I'm already expecting
to see a lot of idiocies posted in journals.

Regards,
Willy

