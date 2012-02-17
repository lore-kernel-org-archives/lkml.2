Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2BQUSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:18:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54258 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2BQUR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:17:59 -0500
Date: Fri, 17 Feb 2012 15:17:23 -0500 (EST)
Message-Id: <20120217.151723.439729747666738170.davem@davemloft.net>
To: richard@nod.at
Cc: danny.kukawka@bisect.de, jdike@addtoit.com, dkukawka@suse.de,
        akpm@linux-foundation.org, jpirko@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] UML net: set addr_assign_type if
 random_ether_addr() used
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F3E787D.4020103@nod.at>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-11-git-send-email-danny.kukawka@bisect.de>
	<4F3E787D.4020103@nod.at>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 12:17:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>
Date: Fri, 17 Feb 2012 16:55:41 +0100

> On 17.02.2012 16:43, Danny Kukawka wrote:
>> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
>> a random MAC address was generated and assigned to the netdevice.
>>
>> Return state from setup_etheraddr() about returning a random
>> MAC address or not and check this state in eth_configure().
>>
>> Signed-off-by: Danny Kukawka<danny.kukawka@bisect.de>
> 
> Acked-by: Richard Weinberger <richard@nod.at>
> 
> Do you want me to pick up this patch or is it supposed to go though
> the net tree?

I'll take care of it.
