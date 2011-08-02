Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1HBLUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:20:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38598 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1HBLUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:20:37 -0400
Date: Tue, 02 Aug 2011 04:20:19 -0700 (PDT)
Message-Id: <20110802.042019.719045752884572940.davem@davemloft.net>
To: rientjes@google.com
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
	<20110802101614.009cdf42@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 02 Aug 2011 04:20:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Tue, 2 Aug 2011 02:53:34 -0700 (PDT)

> That's obviously wrong since all of the applications that I've cited 
> that have been fixed to date have been the result of users actually 
> noticing the printk_once() and emailing me directly to pass it along to 
> the appropriate parties.  I've also found other cases where bugzilla 
> entries were created based on that single line warning by users, who in 
> turn get distros and maintainers to convert to the new interface.
> 
> It's quite effective, but there are still some applications that have yet 
> to be reported, hence the reason for anybody actually hitting this new 
> WARN_ONCE().

I completely agree with you.  Printing out some kind of warning does
get the problems fixed.
