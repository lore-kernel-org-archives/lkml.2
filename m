Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2IVIBl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 04:01:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60323 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2IVIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:01:39 -0400
Subject: Re: [PATCH net-next v1] net: use a per task frag allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vijay Subramanian <subramanian.vijay@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
In-Reply-To: <CAGK4HS98RG78Auvaai3Ny6zz5c_hccO-ShD3GuT=moRRm4+RUA@mail.gmail.com>
References: <1348073761.26523.1095.camel@edumazet-glaptop>
	 <20120920.174827.1245530945282009606.davem@davemloft.net>
	 <1348239433.2669.522.camel@edumazet-glaptop>
	 <CAGK4HS98RG78Auvaai3Ny6zz5c_hccO-ShD3GuT=moRRm4+RUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Sep 2012 23:11:11 +0200
Message-ID: <1348261871.2669.962.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 13:27 -0700, Vijay Subramanian wrote:
> I get the following compile error with the newer version of the patch
> 
> net/sched/em_meta.c: In function ‘meta_int_sk_sendmsg_off’:
> net/sched/em_meta.c:464: error: ‘struct sock’ has no member named
> ‘sk_sndmsg_off’
> make[1]: *** [net/sched/em_meta.o] Error 1
> make: *** [net/sched/em_meta.o] Error 2
> 
> 
> 
> Vijay

Oh well, I wonder what's the expected use of this crap...

Thanks, I'll fix this on v3 !


