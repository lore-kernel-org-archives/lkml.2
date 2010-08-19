Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0HSPb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:31:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49561 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0HSPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XZgtkFFzfqZwy3sJkf5O1BEC12FolMPaZgltM6tULt3rspret4G73+fFkA14WthvqM
         3yUO4AiOr/Qc5wfe4ktxsvI4SBaTQaJefntme3dWg8GoUo5uDC1Y2soIcoQ5Gi8vFQlr
         C1w3m55MbgdwKGWfXycKOBFlzg8Nj3lNCPOQk=
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Changli Gao <xiaosuo@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100819123545.GA4428@Krystal>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
	 <1282033817.2448.18.camel@edumazet-laptop>
	 <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
	 <1282035715.2448.24.camel@edumazet-laptop>
	 <AANLkTinqQ9wXK9Ed3VYTWj_trYJiU+=uTV-FnCxqFvNU@mail.gmail.com>
	 <20100819123545.GA4428@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 17:31:46 +0200
Message-ID: <1282231906.2549.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 19 août 2010 à 08:35 -0400, Mathieu Desnoyers a écrit :

> I made sure it was available on all architectures with that patchset,
> with the intended goal to used it (cmpxchg, cmpxchg_local for 32/64-bit
> and cmpxchg64, cmpxchg64_local for 64-bit) in arch-agnostic tracer code.
> 
> I added a cmpxchg emulated with irqs off for uniprocessor-only
> architectures that did not have CAS support. sparc32 has moved to a
> hashed locked scheme for its atomic operations long ago, which makes the
> full 32 bits available.
> 
> So, all in all, I'd be surprised if an architecture would lack
> cmpxchg() today. It might be possible that a new architecture that just
> came in would not have taken care of deploying cmpxchg, but that should
> be easily fixable.

Thats pretty cool, thanks for clarification !


