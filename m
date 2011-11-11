Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1KKThW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:37:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1KKThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:37:20 -0500
Message-ID: <4EBD796A.4070808@kernel.org>
Date: Fri, 11 Nov 2011 11:37:14 -0800
From: "John 'Warthog9' Hawley" <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: Mercurial linux-kernel repository at kernel.org?
References: <1320998367.16747.127.camel@dagon.hellion.org.uk>  <1321013367.6676.13.camel@Joe-Laptop> <1321034791.5399.195.camel@calx>
In-Reply-To: <1321034791.5399.195.camel@calx>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 Nov 2011 11:37:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I do not use it, but are there any plans to restore it?
> 
> Not on kernel.org, certainly.

I'll actually say, it hasn't been an immediate priority given the number
of other tasks that are more immediately pending.

> I asked the kernel.org admins a while back to send me a copy of the SHA
> map file from my account I needed to continue the mirror elsewhere and
> HPA declined, making some handwaving towards "eventually letting people
> download tarballs of their old accounts".

There hasn't been any serious movement on getting you your home
directory for several reasons:

1) You haven't asked for your account to be reinstated on kernel.org.  I
have no record of you having ever sent in a gpg key at all, let alone
one that's been signed so we can verify you and your request

2) Without a gpg key so we can verify you and your request, we can't
encrypt your home dir and get it to you.

3) You asked hpa directly and not ftpadmin@kernel.org

> As far as I know, "eventually" hasn't happened yet. I guess it's time to
> fire up a new mirror from scratch. It'll be incompatible with old clones
> due to not having the above file and various minor changes in both git
> and hg in the 6 years the original mirror was running. I'll announce it
> when it's done - it'll probably take a while.
