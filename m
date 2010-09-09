Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab0IIDxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:53:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37941
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab0IIDxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:53:03 -0400
Date: Wed, 08 Sep 2010 20:53:20 -0700 (PDT)
Message-Id: <20100908.205320.191416862.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: arnd@arndb.de, fweisbec@gmail.com, tglx@linutronix.de, jkacur@redhat.com,
        sam@ravnborg.org, jblunck@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC] annotating the remaining BKL users
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikfLb+kDZN8aodPwxFuL_VOuyb7AH=eF60MwrWG@mail.gmail.com>
References: <201009082255.33035.arnd@arndb.de>
	<AANLkTikfLb+kDZN8aodPwxFuL_VOuyb7AH=eF60MwrWG@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Sep 2010 17:20:57 -0700

> That said, I'd also like to see a comment _why_ the architectures in
> question depends on the BKL. Some of those look pretty historical (the
> sparc32 register window spill code? Does it _really_ need the BKL at
> all, or is that just a remnant of "let's get the BKL at each kernel
> entry").

It probably doesn't or can be trivially removed.

I'll have a go at this.
