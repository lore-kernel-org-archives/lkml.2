Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0GLSto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:49:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33545 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab0GLStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pkJifqMTSFZrWpLdejeAUsrq9JAUuyXdzUvanjFm5Cs/O0YVUJsGpn3vWVq5a24CZE
         vlE/P0DjDS4iIDu3p4b1Z8Zy5BNBYFqhdpugsEDSmlEIIdomNnx930bO3p5MllG9wc3C
         NzCt8WSGh0eK5x5ewvO+vthqUgHOUXXFaVCvQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTikEGuFtTlIKUfti6GDsdBz99PpKRCs5lEeEM86u@mail.gmail.com>
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
Date: Mon, 12 Jul 2010 15:49:41 -0300
Message-ID: <AANLkTilbEkJWPqvJE72r9HdFQSU84S02BKZB0CH-8QwB@mail.gmail.com>
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

2010/7/11 Felipe W Damasio <felipewd@gmail.com>:
> We're using eth1 facing the user and eth2 facing the internet.

Here's the result using ethtool-2.6.34:

./ethtool -k eth1

Offload parameters for eth1:
rx-checksumming: on
tx-checksumming: on
scatter-gather: on
tcp-segmentation-offload: on
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: off
large-receive-offload: off
ntuple-filters: off
receive-hashing: off


./ethtool -k eth2

Offload parameters for eth2:
rx-checksumming: on
tx-checksumming: on
scatter-gather: on
tcp-segmentation-offload: on
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: off
large-receive-offload: off
ntuple-filters: off
receive-hashing: off
