Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0GMOtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:49:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49276 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0GMOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Nt5ppzagnQa42YbYheYh0Z679LzFp5+7X3xw4RZ9LAbWThw+cb2gCEKCsOL8XKnGzI
         Mqkrp7x3X5jUZPdc5LfmF1yIJbTryt03i/CdFYklVbit8xnn/eSNE20spZ/8QF7h5mad
         Gos8sF0sf/WAyxSVYqkrlIYSFFfXZzF1by/9w=
MIME-Version: 1.0
In-Reply-To: <1279032023.2634.384.camel@edumazet-laptop>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	<AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	<1278626921.2435.73.camel@edumazet-laptop>
	<AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	<1278695580.2696.55.camel@edumazet-laptop>
	<AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	<1278742649.2538.17.camel@edumazet-laptop>
	<4C395459.6080407@redhat.com>
	<1278835332.2538.51.camel@edumazet-laptop>
	<AANLkTikEGuFtTlIKUfti6GDsdBz99PpKRCs5lEeEM86u@mail.gmail.com>
	<AANLkTilbEkJWPqvJE72r9HdFQSU84S02BKZB0CH-8QwB@mail.gmail.com>
	<AANLkTimn9x17g-4K7fS4MjmCgzHuBARurEoFVd_gId7m@mail.gmail.com>
	<1279032023.2634.384.camel@edumazet-laptop>
Date: Tue, 13 Jul 2010 11:49:40 -0300
Message-ID: <AANLkTilrIByt4xAHhsBsKo3nDfv0_c3sF-dCiTiYiPnu@mail.gmail.com>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Felipe W Damasio <felipewd@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mr. Dumazet,

2010/7/13 Eric Dumazet <eric.dumazet@gmail.com>:
> I currently have no fresh ideas. If you want this problem to be solved,
> its important to setup in your lab a workload to trigger again and again
> the bug, in order to provide us more crash information.

 Right. I've been running non-stop since the first bug happened, but
so far the problem hasn't surfaced again :-(

 I've been using the kernel with the patch that you provided me
(nf_tproxy.c). Is there a chance that patch fixed the problem?

 Cheers,

Felipe Damasio
