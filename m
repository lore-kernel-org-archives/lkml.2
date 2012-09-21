Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2IUU1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:27:32 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36239 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2IUU1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <1348239433.2669.522.camel@edumazet-glaptop>
References: <1348073761.26523.1095.camel@edumazet-glaptop>
	<20120920.174827.1245530945282009606.davem@davemloft.net>
	<1348239433.2669.522.camel@edumazet-glaptop>
Date: Fri, 21 Sep 2012 13:27:30 -0700
Message-ID: <CAGK4HS98RG78Auvaai3Ny6zz5c_hccO-ShD3GuT=moRRm4+RUA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: use a per task frag allocator
From: Vijay Subramanian <subramanian.vijay@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following compile error with the newer version of the patch

net/sched/em_meta.c: In function ‘meta_int_sk_sendmsg_off’:
net/sched/em_meta.c:464: error: ‘struct sock’ has no member named
‘sk_sndmsg_off’
make[1]: *** [net/sched/em_meta.o] Error 1
make: *** [net/sched/em_meta.o] Error 2



Vijay
