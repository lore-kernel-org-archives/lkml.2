Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1ESJKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:10:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53732 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab1ESJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:07 -0400
Date: Thu, 19 May 2011 05:08:24 -0400 (EDT)
Message-Id: <20110519.050824.838971689287732822.davem@davemloft.net>
To: sven@narfation.org
Cc: ordex@autistici.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paulus@samba.org, linux-ppp@vger.kernel.org
Subject: Re: net: add seq_before/seq_after functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <201105191054.34912.sven@narfation.org>
References: <1305722319-8315-1-git-send-email-ordex@autistici.org>
	<201105191054.34912.sven@narfation.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 May 2011 02:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>
Date: Thu, 19 May 2011 10:54:32 +0200

> On Wednesday 18 May 2011 14:38:39 Antonio Quartulli wrote:
>> Introduce two operations to handle comparison between packet sequence
>> numbers taking into account overflow/wraparound. Batman-adv uses
>> these functions already to check for successor packet even in case of
>> overflow.
> 
> Thanks for your efforts to bring that to the kernel. But when you prepare a 
> patch then you have to add a signoff. And also David S. Miller is the 
> maintainer for this header - it would be interesting to ask him first when we 
> want to change that file.

Well it makes no sense to add these interfaces until we see an
upstream submission of code which will actually use it.

Also I'm skeptical that such generic sounding interfaces make
sense when it appears to me that these are protocol specific
sequence number tests so probably belong in whatever protocol
is upcoming which will use these interfaces.

Again, this is why we want to see the code that's going to use
these new routines before we can seriously consider adding them
at all.
