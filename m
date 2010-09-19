Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0ISEeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:34:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58178
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab0ISEeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:34:14 -0400
Date: Sat, 18 Sep 2010 21:34:32 -0700 (PDT)
Message-Id: <20100918.213432.193728824.davem@davemloft.net>
To: w@1wt.eu
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.ukg
Subject: Re: [Stable-review] [000/123] 2.6.32.22-stable review
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100918213930.GD11678@1wt.eu>
References: <20100918190024.GA14388@kroah.com>
	<20100918213930.GD11678@1wt.eu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Sat, 18 Sep 2010 23:39:30 +0200

> Hi Greg,
> 
> On Sat, Sep 18, 2010 at 12:00:24PM -0700, Greg KH wrote:
>> [Note, I do still have patches that people have sent me for inclusion in
>> the .32-stable tree in my queue, but I figured this series was already
>> big enough that it should go out now.  If you notice, I _did_ apply all
>> patches that went through Linus's tree with a stable@kernel.org marking
>> on it, so people might consider using that method instead...]
> 
> I'll give this a try, however I really miss the tcp_collapse() fix
> (baff42ab1494528907bf4d5870359e31711746ae) without which 2.6.32.21 panics
> several times a day when using splice().
> 
> I don't know if Davem had time to forward it to you though.

I planned to push things to Greg for -stable Sunday evening.
