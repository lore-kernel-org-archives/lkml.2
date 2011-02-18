Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab1BRUN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:13:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48176
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758516Ab1BRUNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:13:55 -0500
Date: Fri, 18 Feb 2011 12:14:31 -0800 (PST)
Message-Id: <20110218.121431.183035903.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, ebiederm@xmission.com, mingo@elte.hu,
        opurdila@ixiacom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] net: deinit automatic LIST_HEAD
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298019559.2595.92.camel@edumazet-laptop>
References: <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
	<m17hcx7wca.fsf@fess.ebiederm.org>
	<1298019559.2595.92.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 18 Feb 2011 09:59:19 +0100

> commit 9b5e383c11b08784 (net: Introduce
> unregister_netdevice_many()) left an active LIST_HEAD() in
> rollback_registered(), with possible memory corruption.
> 
> Even if device is freed without touching its unreg_list (and therefore
> touching the previous memory location holding LISTE_HEAD(single), better
> close the bug for good, since its really subtle.
> 
> (Same fix for default_device_exit_batch() for completeness)
> 
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Reported-by: Eric W. Biderman <ebiderman@xmission.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
