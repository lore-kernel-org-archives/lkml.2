Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab1JQWpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:45:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab1JQWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:45:41 -0400
Date: Mon, 17 Oct 2011 18:44:10 -0400 (EDT)
Message-Id: <20111017.184410.578309826256473077.davem@davemloft.net>
To: aarcange@redhat.com
Cc: peterz@infradead.org, akpm@linux-foundation.org, minchan.kim@gmail.com,
        walken@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        hughd@google.com, jweiner@redhat.com, riel@redhat.com, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com, shaohua.li@intel.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org
Subject: Re: [PATCH 2/3] sparc: gup_pte_range() support THP based tail
 recounting
From: David Miller <davem@davemloft.net>
In-Reply-To: <1318862517-7042-3-git-send-email-aarcange@redhat.com>
References: <1316793432.9084.47.camel@twins>
	<1318862517-7042-1-git-send-email-aarcange@redhat.com>
	<1318862517-7042-3-git-send-email-aarcange@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 17 Oct 2011 15:44:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Date: Mon, 17 Oct 2011 16:41:56 +0200

> Up to this point the code assumed old refcounting for hugepages
> (pre-thp). This updates the code directly to the thp mapcount tail
> page refcounting.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
