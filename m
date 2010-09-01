Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0IAVZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:25:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44427
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905Ab0IAVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:25:11 -0400
Date: Wed, 01 Sep 2010 14:25:28 -0700 (PDT)
Message-Id: <20100901.142528.180418526.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mingo@elte.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, tj@kernel.org
Subject: Re: vhost_dev_cleanup() crash: BUG: unable to handle kernel NULL
 pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283256357.2550.61.camel@edumazet-laptop>
References: <1283251801.2550.53.camel@edumazet-laptop>
	<20100831111413.GB12853@elte.hu>
	<1283256357.2550.61.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 31 Aug 2010 14:05:57 +0200

> [PATCH v2] vhost: stop worker only if created
> 
> Its currently illegal to call kthread_stop(NULL)
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

I'll apply this thanks Eric.
