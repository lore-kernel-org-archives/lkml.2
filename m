Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1KBXNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:13:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33496 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1KBXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:13:27 -0400
Date: Wed, 02 Nov 2011 19:13:24 -0400 (EDT)
Message-Id: <20111102.191324.1716703336141439504.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tony@atomide.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: Add back alignment for size for __alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111102.190955.1902322759075682192.davem@davemloft.net>
References: <20111102224317.GM31337@atomide.com>
	<4EB1CA4F.3090403@gmail.com>
	<20111102.190955.1902322759075682192.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 02 Nov 2011 16:13:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 02 Nov 2011 19:09:55 -0400 (EDT)

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 02 Nov 2011 23:55:11 +0100
> 
>> There is a problem with your kmalloc() or alignments on your architecture.
>> 
>> What is the SMP_CACHE_BYTES value ?
> 
> kmalloc() behavior doesn't have anything to do with this bug.

Sorry, I take that back, I see now how ksize() and friends are being
used here.
