Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1EYVjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:39:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58041 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab1EYVjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:39:15 -0400
Date: Wed, 25 May 2011 17:39:07 -0400 (EDT)
Message-Id: <20110525.173907.991720348148063903.davem@davemloft.net>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 28/34] atm: Drop __TIME__ usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DDD6B59.9000108@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	<1302015561-21047-29-git-send-email-mmarek@suse.cz>
	<4DDD6B59.9000108@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 May 2011 14:39:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>
Date: Wed, 25 May 2011 22:49:29 +0200

> Dne 5.4.2011 16:59, Michal Marek napsal(a):
>> The kernel already prints its build timestamp during boot, no need to
>> repeat it in random drivers and produce different object files each
>> time.
>> 
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>>  net/atm/lec.c |    2 +-
>>  net/atm/mpc.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Hi,
> 
> I don't see this patch in today's linux-next. Any objection against me
> applying it to the kbuild-2.6.git repository?

Please apply it:

Acked-by: David S. Miller <davem@davemloft.net>
