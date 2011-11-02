Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1KBRqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:46:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KBRqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:46:48 -0400
MIME-Version: 1.0
In-Reply-To: <1320254854.2292.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1318874090.4172.84.camel@twins> <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
 <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
 <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
 <20111018182046.GF1309@hostway.ca> <alpine.LFD.2.02.1110182146440.3240@ionos>
 <20111024190203.GA24410@hostway.ca> <20111025202049.GB25043@hostway.ca>
 <20111031173246.GA10614@hostway.ca> <alpine.LFD.2.02.1111021725550.2829@ionos>
 <1320254854.2292.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Nov 2011 10:46:26 -0700
X-Google-Sender-Auth: w2lE5xjad4q1e5h7qRkWIKmZXdw
Message-ID: <CA+55aFxKtA0XXtiKgKC5qHmFuTv2=TbuMEczkegJKY4Uy00a-g@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Simon Kirby <sim@hostway.ca>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 10:27 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> I believe it might come from commit 0e734419
> (ipv4: Use inet_csk_route_child_sock() in DCCP and TCP.)
>
> In case inet_csk_route_child_sock() returns NULL, we dont release socket
> lock.

Hmm. I'm not seeing it. We're not even taking the socket lock there.
Or is it hidden somehow?

                    Linus
