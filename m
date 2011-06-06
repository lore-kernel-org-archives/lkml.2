Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1FFNaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:30:13 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40311 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1FFNaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:30:11 -0400
Message-ID: <4DECD657.9010807@ahsoftware.de>
Date: Mon, 06 Jun 2011 15:29:59 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
Subject: Re: bridge/netfilter: regression in 2.6.39.1
References: <4DE93422.3070000@ahsoftware.de>	 <20110606111507.GA1000@hmsreliant.think-freely.org>	 <4DECBEA3.6070408@ahsoftware.de> <1307362358.3098.6.camel@edumazet-laptop>	 <4DECCCC0.70905@ahsoftware.de> <1307366166.3098.15.camel@edumazet-laptop>
In-Reply-To: <1307366166.3098.15.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Nice, now please submit a patch with 0972ddb237 as a guideline.
>
> BTW, you could also check other struct dst_ops methods for
> bridge/netfilter:

Sorry, but I prefer to submit patches I understand by myself and for 
stuff I know something about. The patch in my first mail was just meant 
as a quick fix (which seemed to work here).

So even if I might be able to construct a working patch using commit 
0972ddb237, I don't think I should do that.

Regards,

Alexander
