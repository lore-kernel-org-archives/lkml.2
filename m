Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0G3ASr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:18:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53534 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab0G3ASp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fikoy0qoyvfMoYElfYGNSqI4GYkAH5LkHZ3FPKMRUJR1jHaPvUf6Omn3yLRCq7fxLL
         U4CKf0WkQTxpuRYNix5klTVseKHBtYRpaTqpoDi2ObnIOvCGaCu/zxSuLJQPdJOcIUHE
         LenIVNgfpEJoWlpxuIHrgq/sMf46p8nJU70JQ=
MIME-Version: 1.0
In-Reply-To: <e90ce59d7dcbbdb24e1882a4e99b0c3db2bd116a.1280447281.git.joe@perches.com>
References: <cover.1280447281.git.joe@perches.com> <e90ce59d7dcbbdb24e1882a4e99b0c3db2bd116a.1280447281.git.joe@perches.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 29 Jul 2010 20:18:24 -0400
Message-ID: <AANLkTikYn+qpDxxLeJ4eu5SsEs=7n_wAu5RzM5pZhVwU@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] drivers/net/bfin_mac.c: Misc function 
	cleanups, neatening
To: Joe Perches <joe@perches.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 19:58, Joe Perches wrote:
> Use new bfin_alloc_skb to centralize skb allocations
> Add and use get_mac_addr function
> Neaten bfin_mac_init
> Neaten bfin_mac_hard_start_xmit

i'll ack the idea, but i think it better i pull these patches into the
Blackfin repo to get some real hardware testing before i forward them
back to David/netdev ...

that OK with you ?
-mike
