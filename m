Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1CAFpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:45:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49530 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1CAFpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:45:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cU7bZ44bXwX/DQeWwU/cUmRfXhpeZan6Kxwyb/J8QwN5RTo4c8vX1t2CS3831uQf3i
         CWUmDxAwVRPyNBTmk3d+bbg39oj6gJDwFSEMt2RpZ7QL7s0Tw4CPh0SA9K2B2yZkRs2B
         OpuMUsT4vsqo1cMrz3/e05tEda1mnnheHlYzM=
Subject: Re: [PATCH v6] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
References: <1298539762-2242-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298634040.2659.32.camel@edumazet-laptop>
	 <AANLkTimeDR27Q7fcBmB0ix7Q_pRT_GDpc7S3LO21-fh-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 06:45:36 +0100
Message-ID: <1298958336.2676.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 13:20 +0800, Po-Yu Chuang a écrit :

> That means, since every rx buffer is large enough, it is impossible to
> get a multi-segment packets.
> 
> So I simplified ftmac100_rx_packet().

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

I am only wondering then if not using fragments would be faster then
(eventually doing copybreaks for small frames like tg3)

But if you plan to get new hw soon, you have the infrastructure...



