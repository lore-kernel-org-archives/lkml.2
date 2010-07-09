Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0GISQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:16:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48502 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0GISQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rxZU+y7tPQKwdSRx3ZcZSVTZSuJSltLw4Xs2+c3ACPa7d7ygBrOddP4UqGf0Xrp3Dv
         kbPVZJ8ZZu/BiRASJADIJxf/AoFWjT2ySgjuDadUXezpFHWzeAwQZsEb+qMvL6lVgXYy
         8PfUIDeT3azdmX9WaqptyT/s7hSqOH3vZTanw=
MIME-Version: 1.0
In-Reply-To: <1278695580.2696.55.camel@edumazet-laptop>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	<AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	<1278626921.2435.73.camel@edumazet-laptop>
	<AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	<1278695580.2696.55.camel@edumazet-laptop>
Date: Fri, 9 Jul 2010 15:16:17 -0300
Message-ID: <AANLkTilwWI7wt-Bo45S_bpDV8MEu67jyB63kiZHB-C-P@mail.gmail.com>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Felipe W Damasio <felipewd@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/7/9 Eric Dumazet <eric.dumazet@gmail.com>:
> Reviewing tproxy stuff I spotted a problem in nf_tproxy_assign_sock()
> but I could not see how it could explain your crash.
>
> We can read uninitialized memory and trigger a fault in
> nf_tproxy_assign_sock(), not later in tcp_recvmsg()...

Well, since I can't reproduce the bug, if you think this patch solves
my problem, I'll tell my bosses that we can put back the production
machine online.

But anyway, if there's test you think I can run, I have same the same
hardware on a lab using the same setup as the production
environment...

Thanks,

Felipe Damasio
