Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1KZK7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:59:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64254 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1KZK72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:59:28 -0500
Message-ID: <1322305162.10212.8.camel@edumazet-laptop>
Subject: Re: [BUG] 3.2-rc2: BUG kmalloc-8: Redzone overwritten
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: David Miller <davem@davemloft.net>, Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Sat, 26 Nov 2011 11:59:22 +0100
In-Reply-To: <1322304878.28191.1.camel@sasha>
References: <1321866845.3831.7.camel@lappy>
	 <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321870915.2552.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321870967.8173.1.camel@lappy> <1322304878.28191.1.camel@sasha>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 26 novembre 2011 à 12:54 +0200, Sasha Levin a écrit :
> > On Mon, 2011-11-21 at 11:21 +0100, Eric Dumazet wrote:
> > > 
> > > Hmm, I forgot to remove the sock_hold(sk) call from dn_slow_timer(),
> > > here is V2 :
> > > 
> > > [PATCH] decnet: proper socket refcounting
> > > 
> > > Better use sk_reset_timer() / sk_stop_timer() helpers to make sure we
> > > dont access already freed/reused memory later.
> > > 
> > > Reported-by: Sasha Levin <levinsasha928@gmail.com>
> > > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > > ---
> > 
> > 
> > Applied locally and running same tests as before, will update with
> > results.
> > 
> 
> Looks ok after a couple days of testing.
> 
> 	Tested-by: Sasha Levin <levinsasha928@gmail.com>
> 

Thanks Sasha !


