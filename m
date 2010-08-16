Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0HPJxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:53:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55293 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0HPJxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        b=bIWEaQQ62C2PGzMQVGaTqmYnitk9aux+jd58XuEsi6OZ1pwrWWd5oHB2hKWSv63t+K
         l46NJdeQc/NaaMpX7LslpTQTiJexo79WH6n20rUhzrhfeq6fsG8+codUtPljEymawEvi
         Im7RvFfjPYtYQE+1nHezO52Nldx/TBzVcBU30=
Date: Mon, 16 Aug 2010 09:53:25 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [GIT] Networking
Message-ID: <20100816095325.GA8547@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1281883637.2942.42.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le dimanche 15 aou^t 2010 a` 12:55 +0200, Eric Dumazet a écrit :
...
> [PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive
> 
> After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
> bottom half more than necessary), lockdep can raise a warning
> because we attempt to lock a spinlock with BH enabled, while
> the same lock is usually locked by another cpu in a softirq context.

Btw, could you remind us how get_counters() are serialized (I guess
you can't have them on 2 cpus at the same time)?

Thanks,
Jarek P.
