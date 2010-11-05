Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0KETqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:46:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40527 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0KETqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QCglqgZBKko7PlG4025liuZOsKfqBjXmXpNc2vy1x3l8kNYj9rXN4Z5y+8ICoQnpYE
         y8p5FaHlsmqdJstpNwt43xmsey99KG7naW1AL9Fj8ttn8Suk4X7FCd0SHs6NCg+uPw01
         CrJV9uu3HWwHca3Nicjv1l0w74hrWGrmBYPbI=
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <20101105123927.5779e464.akpm@linux-foundation.org>
References: <1288975980.2882.877.camel@edumazet-laptop>
	 <20101105102038.53e36f9e.akpm@linux-foundation.org>
	 <1288980046.2882.1054.camel@edumazet-laptop>
	 <20101105110828.52f061b3.akpm@linux-foundation.org>
	 <1288981224.2882.1105.camel@edumazet-laptop>
	 <20101105112821.57f80481.akpm@linux-foundation.org>
	 <1288984844.2665.52.camel@edumazet-laptop>
	 <20101105123927.5779e464.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 20:46:31 +0100
Message-ID: <1288986391.2665.157.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 12:39 -0700, Andrew Morton a écrit :

> Ah.  I wasn't able to see much duplicated code at all, so I wasn't sure
> that we needed to bother about this issue.
> 
> yup, atomic_inc_not_zero() looks like a candidate.

yes, and atomic_add_unless()...

> 
> > [PATCH v3] atomic: add atomic_inc_not_zero_hint()
> 
> Let's go with this for now ;)
> 
> I'll assume that you intend to make use of this function soon, and it
> looks safe enough to sneak it into 2.6.37-rc2, IMO.  If Linus shouts at
> me then we could merge it into 2.6.38-rc1 via net-next, but I think
> straight-to-mainline is best.
> 

Well, I dont expect using it before 2.6.38, no hurry Andrew, but it
probably can be merged before, since it has no user yet. It'll help our
job for sure.

Thanks


