Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937484Ab0CPHNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:13:08 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55788 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0CPHNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GEX7VlUxOdFD18veF1vhEgCKrj+hDtp/cwoRKuyslUS+BYpfPuOhD8aazvoRO1l3rK
         TOc3n6lpSlsOuWXlQt9OJhMVb6yoZCOlSvfrodstE4OuAnEF7RxbS4YK6fmGaF3Dj2uZ
         YA1rqeldxH8znRNVuIYm/es08nZjLeN3UbZ7o=
Subject: Re: [PATCH] r8169: Fix rtl8169_rx_interrupt()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Francois Romieu <romieu@fr.zoreil.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100316065015.GA3336@swordfish.minsk.epam.com>
References: <20100307192305.GA598@elte.hu>
	 <20100308125122.GA11242@redhat.com>
	 <1268686865.2824.4.camel@edumazet-laptop>
	 <1268699602.2824.14.camel@edumazet-laptop>
	 <20100316065015.GA3336@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 08:12:57 +0100
Message-ID: <1268723577.2824.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 16 mars 2010 à 08:50 +0200, Sergey Senozhatsky a écrit :
> Hello,
> 
> Sure. Give me a couple of days. By the way, should I test against .34
> or .33?
> 

It's an old bug anyway, so you can pick up whats is the best for you.
My personal pref would be current kernel.

To trigger the original condition (fifo overflow), you might flood your
machine from another one with small packets, for example using pktgen.

Thanks


