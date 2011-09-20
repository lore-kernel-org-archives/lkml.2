Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1ITQUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:20:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:26372 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1ITQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:20:15 -0400
Message-ID: <4E78BD31.8090509@parallels.com>
Date: Tue, 20 Sep 2011 20:20:01 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/8] SUNRPC: introduce helpers for reference counted
 rpcbind clients
References: <20110920101031.9861.18444.stgit@localhost6.localdomain6>	<20110920101341.9861.51453.stgit@localhost6.localdomain6>	<4E7899E7.9090809@parallels.com>	<20110920102431.58ca1d96@tlielax.poochiereds.net>	<4E78A6A1.1000800@parallels.com> <20110920111112.3f07cd6e@tlielax.poochiereds.net>
In-Reply-To: <20110920111112.3f07cd6e@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.09.2011 19:11, Jeff Layton пишет:
>
> In general, it's difficult to get locking right, especially when you
> start mixing multiple locks on related resources. Personally, I'd go
> with a simpler scheme here. There's not much value in protecting this
> counter with a spinlock when the other parts need to be protected by a
> mutex. If you do decide to do it with multiple locks, then please do
> document in comments how the locking is expected to work.
>
> An alternate scheme might be to consider doing this with krefs, but I
> haven't really considered whether that idiom makes sense here.
>

Jeff, please, have a look at my answer to Bryan Schumaker.
Does it allay your apprehensions?

-- 
Best regards,
Stanislav Kinsbursky
