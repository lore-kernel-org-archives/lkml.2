Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0IAVsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:48:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0IAVsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:48:22 -0400
Date: Thu, 2 Sep 2010 00:42:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, mingo@elte.hu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: vhost_dev_cleanup() crash: BUG: unable to handle kernel NULL
 pointer dereference
Message-ID: <20100901214221.GA15182@redhat.com>
References: <1283251801.2550.53.camel@edumazet-laptop>
 <20100831111413.GB12853@elte.hu>
 <1283256357.2550.61.camel@edumazet-laptop>
 <20100901.142528.180418526.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901.142528.180418526.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 02:25:28PM -0700, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 31 Aug 2010 14:05:57 +0200
> 
> > [PATCH v2] vhost: stop worker only if created
> > 
> > Its currently illegal to call kthread_stop(NULL)
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> I'll apply this thanks Eric.

Yes, it looks good thanks!
Acked-by: Michael S. Tsirkin <mst@redhat.com>

Or you can wait for my pull request (will have a couple other regression
fixes).
