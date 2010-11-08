Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0KHVnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:43:41 -0500
Received: from smtp-out.google.com ([74.125.121.35]:48275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab0KHVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gJRkkNVGtEcb7tqnR7EOjCrYrImn/GUDAg9Y9IAmxn6vbWQFo9mNwqaa2E8K8KPvtr
         FN0iQU8X506bk5ibedGg==
MIME-Version: 1.0
In-Reply-To: <20101108.132051.48494580.davem@davemloft.net>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <1289249727.18612.228.camel@calx> <20101108.132051.48494580.davem@davemloft.net>
From: Mike Waychison <mikew@google.com>
Date: Mon, 8 Nov 2010 13:43:16 -0800
Message-ID: <AANLkTinP+5OFt7Gk0DoMZ3j2YeaGSTzb=aMfdKcsHgYH@mail.gmail.com>
Subject: Re: [PATCH v2 00/23] netoops support
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, simon.kagstrom@netinsight.net, nhorman@tuxdriver.com,
        adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        greg@kroah.com, xiyou.wangcong@gmail.com, akpm@linux-foundation.org,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 1:20 PM, David Miller <davem@davemloft.net> wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Mon, 08 Nov 2010 14:55:27 -0600
>
>> This much of your set looks very nice to me, but I'd like to get some
>> more eyeballs on the first four. Dave?
>
> If it's not sent to netdev, I'm less likely to see it :-)
>

My bad :(   I'll send it to netdev on the next version (unless told otherwise).
