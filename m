Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0IBB10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:27:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45494
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab0IBB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:27:25 -0400
Date: Wed, 01 Sep 2010 18:27:41 -0700 (PDT)
Message-Id: <20100901.182741.73368486.davem@davemloft.net>
To: mst@redhat.com
Cc: eric.dumazet@gmail.com, mingo@elte.hu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: vhost_dev_cleanup() crash: BUG: unable to handle kernel NULL
 pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100901214221.GA15182@redhat.com>
References: <1283256357.2550.61.camel@edumazet-laptop>
	<20100901.142528.180418526.davem@davemloft.net>
	<20100901214221.GA15182@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 2 Sep 2010 00:42:21 +0300

> On Wed, Sep 01, 2010 at 02:25:28PM -0700, David Miller wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Tue, 31 Aug 2010 14:05:57 +0200
>> 
>> > [PATCH v2] vhost: stop worker only if created
>> > 
>> > Its currently illegal to call kthread_stop(NULL)
>> > 
>> > Reported-by: Ingo Molnar <mingo@elte.hu>
>> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> 
>> I'll apply this thanks Eric.
> 
> Yes, it looks good thanks!
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Or you can wait for my pull request (will have a couple other regression
> fixes).

I'll keep it in my tree and whether it's in your's or not git merge
will work it out.
