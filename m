Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0FCWpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:45:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263Ab0FCWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:45:04 -0400
Date: Thu, 3 Jun 2010 15:40:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Mohr <andi@lisas.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <20100603223259.GA4085@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1006031535570.8175@i5.linux-foundation.org>
References: <20100603223259.GA4085@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Andreas Mohr wrote:
> 
> http://such001.reichelt.de/?SID=31BKCyV6wQAR8AAHJNE7U6761b7ea498b06ffe19b1e0abcdc120b;ACTION=444
> http://www.kmelektronik.de/shop/index.php?show=subgroup&group=53&subgroup=117&Sort=2
> http://www.arlt.com/index.php?cl=search&searchparam=floppy

Ok, ok. I admit it. I was being a bit facetious. You can still buy them 
online. In fact, according to newegg, you can get them really cheap (the 
USB floppy drives cost $20, but you can get a _genuine_ floppy drive for 
$7.99.

Although one comment says it all:

	Cons: I ordered 5. After 45 days 3 of them have failed. Too late to return.

so apparently you do need to order a lot of them to keep them going ;)

So here's a one-time offer: if you want to really fix that driver, I'm 
willing to pay the $7.99 to buy the hardware for you. I won't touch it 
myself with a 10-foot pole, though ;)

		Linus
