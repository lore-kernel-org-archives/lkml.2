Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0GNDnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:43:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0GNDnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F43/3ezNFyxuhEI5G7ycfSgOQs8h+/KTdOS7HVrSRgEYjhzDvQ2z5R4VjPKsGvkwHW
         JEh47RkMF2bBp4LTJOjlq/nIXl4vuGBIaRXbZh7v3lpx35XXi1l5PA9djgSuSd9gHN+w
         JhU9rrEWJXLQk3Q0krpWLWr0vggqainbfCCEE=
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felipe W Damasio <felipewd@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTikkcaionMp3SJLgo3JmCjxQ7rPZv3-3_RbxCx_4@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	 <1278626921.2435.73.camel@edumazet-laptop>
	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	 <1278695580.2696.55.camel@edumazet-laptop>
	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	 <1278742649.2538.17.camel@edumazet-laptop> <4C395459.6080407@redhat.com>
	 <1278835332.2538.51.camel@edumazet-laptop>
	 <AANLkTikEGuFtTlIKUfti6GDsdBz99PpKRCs5lEeEM86u@mail.gmail.com>
	 <AANLkTilbEkJWPqvJE72r9HdFQSU84S02BKZB0CH-8QwB@mail.gmail.com>
	 <AANLkTimn9x17g-4K7fS4MjmCgzHuBARurEoFVd_gId7m@mail.gmail.com>
	 <1279032023.2634.384.camel@edumazet-laptop>
	 <AANLkTilrIByt4xAHhsBsKo3nDfv0_c3sF-dCiTiYiPnu@mail.gmail.com>
	 <1279036193.2634.468.camel@edumazet-laptop>
	 <AANLkTilgxvDPpBJvwbw3PHZfXDaa2_6-TbJ8lujz5y3V@mail.gmail.com>
	 <1279077678.2444.95.camel@edumazet-laptop>
	 <AANLkTikkcaionMp3SJLgo3JmCjxQ7rPZv3-3_RbxCx_4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 05:43:05 +0200
Message-ID: <1279078985.2444.105.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 juillet 2010 à 00:27 -0300, Felipe W Damasio a écrit :
> Hi Mr. Dumazet,
> 
> 2010/7/14 Eric Dumazet <eric.dumazet@gmail.com>:
> > RDX being the sk pointer (and sk+0x38 contains the corrupted "sk_prot" value)
> > , we notice RBP contains same "sk" value + 0x200000  (2 Mbytes).
> >
> > (same remark on your initial bug report)
> >
> > Could you enable CONFIG_FRAME_POINTER=y in your config ?
> 
> I can, but my bosses will kick my ass if I bring down the ISP again :)
> 

I have no guarantee at all, even if we find the bug.

> If you think it's the only way to find the problem I'll tell them that
> I need to do it. In this case, please tell me what other config
> options/tools I can use to get as much info as possible...since I'll
> probably be able to test this only once more on the production
> environment for debugging purposes.
> 

You really should try to setup a lab to trigger the bug, and not doing
experiments on production :)



