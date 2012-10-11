Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab2JKCS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:18:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35795 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950Ab2JKCPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <1349897005.2035.24.camel@joe-AO722>
References: <1349894559.2035.12.camel@joe-AO722>
	<1349895710.21172.7235.camel@edumazet-glaptop>
	<1349897005.2035.24.camel@joe-AO722>
Date: Thu, 11 Oct 2012 10:15:51 +0800
Message-ID: <CAM_iQpWn8XHZ8VwRGFPjcAvPRAPy82eFT=5tqVzWHq5iXff_wA@mail.gmail.com>
Subject: Re: [PATCH net-next? V2] pktgen: Use simpler test for non-zero ipv6 address
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Brian Haley <brian.haley@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 3:23 AM, Joe Perches <joe@perches.com> wrote:
> Reduces object size and should be slightly faster.
>
> allyesconfig:
> $ size net/core/pktgen.o*
>    text    data     bss     dec     hex filename
>   52284    4321   11840   68445   10b5d net/core/pktgen.o.new
>   52310    4293   11848   68451   10b63 net/core/pktgen.o.old
>
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good.

This should go to -net, net-next is not open currently.

Thanks.
