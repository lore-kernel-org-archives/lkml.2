Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1K1RGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:06:21 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5273 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1K1RGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:06:20 -0500
Message-ID: <4ED3BF8A.1090300@caviumnetworks.com>
Date: Mon, 28 Nov 2011 09:06:18 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        "Daney, David" <David.Daney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jamie Iles <jamie@jamieiles.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] char: hw_random: convert drivers/char/hw_random/* to
 use module_platform_driver()
References: <1322313066.6001.3.camel@phoenix>
In-Reply-To: <1322313066.6001.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2011 17:06:19.0290 (UTC) FILETIME=[0C0DF7A0:01CCADF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 05:11 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/char/hw_random/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Alexander Clouter<alex@digriz.org.uk>
> Cc: David Daney<ddaney@caviumnetworks.com>
> Cc: David S. Miller<davem@davemloft.net>
> Cc: Herbert Xu<herbert@gondor.apana.org.au>
> Cc: Jamie Iles<jamie@jamieiles.com>
> Cc: Josh Boyer<jwboyer@linux.vnet.ibm.com>
> Cc: Matt Mackall<mpm@selenic.com>
> Cc: Olof Johansson<olof@lixom.net>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/char/hw_random/atmel-rng.c      |   12 +-----------
>   drivers/char/hw_random/n2-drv.c         |   13 +------------
>   drivers/char/hw_random/octeon-rng.c     |   13 +------------
>   drivers/char/hw_random/pasemi-rng.c     |   12 +-----------
>   drivers/char/hw_random/picoxcell-rng.c  |   12 +-----------
>   drivers/char/hw_random/ppc4xx-rng.c     |   12 +-----------
>   drivers/char/hw_random/timeriomem-rng.c |   13 +------------
>   7 files changed, 7 insertions(+), 80 deletions(-)
>

For the octeon-rng bit,

Acked-by: David Daney<david.daney@cavium.com>

Thanks,
David Daney

[...]
