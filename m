Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1FTUv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:51:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab1FTUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:in-reply-to:x-mailer:subject:references:message-id
         :content-type:content-transfer-encoding:mime-version:date:cc;
        b=Yh9YADxNaDI69/4QA5hOWJD92erc94Y4cXGKmte9rjPyyVJ50E9J8BmRiE66PSK8Wl
         wZNyV96JVKSH+RPI4ZtwkRjxmeNEtlc1dmkfO6vBUh9UT2dZys2n/X2NHEMD1l7sk/1Q
         Yap+b2BesclPQIcDqGyEUp+BcWd9fto7vdYcc=
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20110620.130515.1956879930278498236.davem@davemloft.net>
X-Mailer: iPhone Mail (7A341)
Subject: Re: [PATCH][Trivial]: ipv4, ping: Remove duplicate icmp.h include
References: <alpine.LNX.2.00.1106201028340.18991@swampdragon.chaosbits.net> <20110620.130515.1956879930278498236.davem@davemloft.net>
Message-Id: <415E440A-6C7F-4ADB-AE81-05AEAD5C3269@gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7A341)
Date: Mon, 20 Jun 2011 23:50:38 +0300
Cc: "jj@chaosbits.net" <jj@chaosbits.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "segoon@openwall.com" <segoon@openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

It's already in Jiri's trivial tree.

Vitaliy

Sent from my iPhone

On Jun 20, 2011, at 23:05, David Miller <davem@davemloft.net> wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Date: Mon, 20 Jun 2011 10:31:20 +0200 (CEST)
>
>> Remove the duplicate inclusion of net/icmp.h from net/ipv4/ping.c
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>
> Applied.
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
