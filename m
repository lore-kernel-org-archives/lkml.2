Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1GAD1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:27:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1GAD1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:27:00 -0400
Message-ID: <4E0D3E80.5080209@redhat.com>
Date: Fri, 01 Jul 2011 11:26:56 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] netpoll: Trivial updates
References: <cover.1309482314.git.joe@perches.com>
In-Reply-To: <cover.1309482314.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月01日 09:08, Joe Perches 写道:
> cc: WANG Cong<amwang@redhat.com>
>
> Joe Perches (2):
>    netpoll: Remove unused EXPORT_SYMBOLs of netpoll_poll and netpoll_poll_dev
>    netpoll: Remove trivial wrapper function netpoll_poll
>
>   include/linux/netpoll.h |    2 --
>   net/core/netpoll.c      |   13 +++----------
>   2 files changed, 3 insertions(+), 12 deletions(-)
>

I am fine with patch 1/2, but not 2/2, since it is trivial,
why touch it? With netpoll_poll(), we don't need to explore the
details of struct netpoll, I think it is nice to have it.

BTW, you can kill the export of netpoll_send_skb_on_dev() too.

Thanks.
