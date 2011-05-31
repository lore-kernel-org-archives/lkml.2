Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1EaTsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:48:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37902 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1EaTsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:48:19 -0400
Date: Tue, 31 May 2011 12:46:30 -0700 (PDT)
Message-Id: <20110531.124630.449848946.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: josh@joshtriplett.org, netdev@vger.kernel.org, serge@hallyn.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kel@otaku42.de, pkg-sysvinit-devel@lists.alioth.debian.org
Subject: Re: [PATCH] uts: Make default hostname configurable, rather than
 always using "(none)"
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTikgqkd0BckvTrFwAOmJQ0ObP4OOjg@mail.gmail.com>
References: <20110530223847.GA29245@leaf>
	<BANLkTikgqkd0BckvTrFwAOmJQ0ObP4OOjg@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 12:46:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 May 2011 20:35:37 +0900

> On Tue, May 31, 2011 at 7:38 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>>
>> The "hostname" tool falls back to setting the hostname to "localhost" if
>> /etc/hostname does not exist.  Distribution init scripts have the same
>> fallback.  However, if userspace never calls sethostname, such as when
>> booting with init=/bin/sh, or otherwise booting a minimal system without
>> the usual init scripts, the default hostname of "(none)" remains,
>> unhelpfully appearing in various places such as prompts
>> ("root@(none):~#") and logs.  Furthermore, "(none)" doesn't typically
>> resolve to anything useful.
> 
> Ok, I'm fine with this. So Ack as far as I'm concerned.
> 
> Does this make most sense through the networking tree, or what?

Linus, you can just apply this directly.

Thanks!
