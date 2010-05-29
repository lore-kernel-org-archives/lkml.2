Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0E2HF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 03:05:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56591
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab0E2HFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 03:05:54 -0400
Date: Sat, 29 May 2010 00:06:04 -0700 (PDT)
Message-Id: <20100529.000604.58441219.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: Luis.Rodriguez@atheros.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1c: Add AR8151 v2 support and change L0s/L1
 routine
From: David Miller <davem@davemloft.net>
In-Reply-To: <12750324381174-git-send-email-jie.yang@atheros.com>
References: <12750324381174-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Fri, 28 May 2010 15:40:38 +0800

> From: Jie.Yang@atheros.com
> 
> Add AR8151 v2.0 Gigabit 1000 support
> Change jumbo frame size to 6K
> Update L0s/L1 rountine
> Update atl1c_suspend routine.
> 
> Signed-off-by: Jie.Yang@atheros.com

Your commit log message is way too terse.

You should describe in detail what your changes are.

Saying "Update L0s/L1 routine" doesn't tell us exactly what change
you are making.  And more importantly, it does not tell us why you
are making this change.

This also applied to "update atl1c_suspend routine" You have to
list exactly change you are making, and why.

You should be able to write a full paragraph explaining what each
change is, and the reason for that change.  This means 4 to 5 full
english sentences, which means more than 3 or 4 words in each
sentence.

Do not try to put as minimal amount of information into your commit
messages as possible, instead strive to put too much information.
Be long winded, and verbose, because you cannot predict what details
of your change and reasoning will be important to someone in the future.

Because some day someone will read your commit patch and wonder the
reasons why you made your changes.

I am not applying this patch until the commit message is made more
verbose and reasonable.
