Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab0GIQDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:03:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49744 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab0GIQDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gqb8FkxXGx2VGDXXljZu4FCiIv/OR5I8Rp+5FGXDRRROuFMksw0XNe3m6CvoW2UUsC
         4L8DRitpwvn/yz+T4sOUPx7nucumrDXBuAYlKcbDyyJS2yHPP0La3EQ5xqbKPIm1PPBf
         oA3EKx7UMccahRjIMeDubGrCryUsijRnl796s=
MIME-Version: 1.0
In-Reply-To: <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	<AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	<1278626921.2435.73.camel@edumazet-laptop>
	<AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
Date: Fri, 9 Jul 2010 13:03:14 -0300
Message-ID: <AANLkTilsfYo2WlRsp1_lTXRTlRwbpgu4oIbWnHtLt3mP@mail.gmail.com>
Subject: Re: Squid hang up on 2.6.34
From: Felipe W Damasio <felipewd@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

2010/7/9 Felipe W Damasio <felipewd@gmail.com>:
> I'm trying..the thing is the freeze occured on the machine that sits
> on a 200Mbps ISP in bridge-mode. Since the machine frooze, and the
> whole ISP went down for a few minutes, I'm not allowed to run any
> tests on it.

The only thing I could track down is going through squid's cache.log,
I found these 2 entries a second before the general protection fault:

2010/07/08 14:51:10| httpReadReply: Excess data from "POST
http://bps.uol.com.br/send.html?ro=2VxogIeFwqQdX.ymjRSChUT67HabcLKfYsPrWlpnBtukZ5v8MANz10GJ4i9O3ED-7xl4ng7XW7RvS8AZ.9OP7WbPHhNq6tyh.0eDB5jl2W56wOu.El0KGg8i-bezIAunlQmJ9tFLERUth9-skZOlSnIUeKQeMqaG18kG8z9.tmkxvWMQtTq.fpUiv3mg5.oqN9ZtNuWqtu61GQGOCCQBKjcwTRMlkBCUoJzrOxMgIENaCwuoqHrK29WcpruyeYyDzv3Y2WFh92H-akWXJAFaPyiP-ZIILxBsSZCSmhY3wC-6lS4t.J6z4ek.J6u71vC8nEsYEhLPQBwHVICEpdqpBsW50pa2ooD32sTtUswlcUOU4iEnz8nX1ZRJLF.jOKH7ZPzCIHkAFF1ZAP87xjztOGTncc0X.7d5lwkdITonWzz1El7KLHmz8hB5sluq0Dus-RLbsCNFd0K4URoZLx6bKrypT.xcxL0ampRb.j.8Cais-IdyQDH43n3Z5TVoq5qjNVgPVIY4zA7omN8Wm5hoYIUUVzLUFhFV8hWc4PtPc7hjJK1audQf7jLB4mK5FaFR6VI9OxNTASehc0iZ8Nhee2YbAUxYLPbz.A3qb5iymjZ@&nout=1"
2010/07/08 14:51:10| clientTryParseRequest: FD 6088
(187.16.240.122:2035) Invalid Request

I suppose the last "Invalid request" triggered the bug. But like I
said, I don't know what I can do to help and fix this.

Cheers,

Felipe Damasio
