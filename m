Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0GMObk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:31:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54955 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0GMObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B3te9EMtdVus/E2HwB5G+L/nZhr4uAo9PdH99mxW30FlxAoUV8REFXtJySbKvV5hBZ
         LXyRxlRJIG6KDgG9T5sllf7VPMrY1YhQlreGMYNpVY/VVGNQv0OL7eHzTccZZW0tPW+4
         IRZ+on9PDknVkFwH6DbQpCOBYXdzXn1xwGVio=
MIME-Version: 1.0
In-Reply-To: <AANLkTilbEkJWPqvJE72r9HdFQSU84S02BKZB0CH-8QwB@mail.gmail.com>
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
Date: Tue, 13 Jul 2010 11:24:58 -0300
Message-ID: <AANLkTimn9x17g-4K7fS4MjmCgzHuBARurEoFVd_gId7m@mail.gmail.com>
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

2010/7/12 Felipe W Damasio <felipewd@gmail.com>:
> Here's the result using ethtool-2.6.34:
>
> ./ethtool -k eth1
>
> Offload parameters for eth1:
> rx-checksumming: on
> tx-checksumming: on
> scatter-gather: on
> tcp-segmentation-offload: on
> udp-fragmentation-offload: off
> generic-segmentation-offload: on
> generic-receive-offload: off
> large-receive-offload: off
> ntuple-filters: off
> receive-hashing: off
>
>
> ./ethtool -k eth2
>
> Offload parameters for eth2:
> rx-checksumming: on
> tx-checksumming: on
> scatter-gather: on
> tcp-segmentation-offload: on
> udp-fragmentation-offload: off
> generic-segmentation-offload: on
> generic-receive-offload: off
> large-receive-offload: off
> ntuple-filters: off
> receive-hashing: off

Did these help you track down the issue?

Sorry to insist, it's just that my bosses are kind of pressuring me to
solve the problem and put the squid machine back online :-)

Is there a test I can run to try and trigger the issue?

I have the same scenario (hardware and network setup) on my lab...

Cheers,

Felipe Damasio
