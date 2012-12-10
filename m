Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2LJUYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:24:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59540 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2LJUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:24:06 -0500
Date: Mon, 10 Dec 2012 15:23:56 -0500 (EST)
Message-Id: <20121210.152356.1449949752496567529.davem@davemloft.net>
To: jwerner@chromium.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kaber@trash.net, yoshfuji@linux-ipv6.org, jmorris@namei.org,
        kuznet@ms2.inr.ac.ru, eric.dumazet@gmail.com, snanda@chromium.org,
        msb@chromium.org
Subject: Re: [PATCH] tcp: Avoid infinite loop on recvmsg bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAODwPW_P_UNGV8rRC7hFC+PBrWeu64ODu5mTby=9GCqMnyDtdQ@mail.gmail.com>
References: <CAODwPW90mZuCDgYPZEJtYNOGGt752VpP=S_EYACUCGua_x=WjA@mail.gmail.com>
	<1352431796.19779.536.camel@edumazet-glaptop>
	<CAODwPW_P_UNGV8rRC7hFC+PBrWeu64ODu5mTby=9GCqMnyDtdQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've tossed these two patches under the carpet, so you'll need to
repost whichever one you want me to consider.

Basically, discussing old patches is pretty useless without a resend
to get it back into the fore-front of the patchwork queue.  So please
don't reference old stale patches without an associated repost like
this.

Thanks.
