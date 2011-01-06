Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1AFV4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:56:11 -0500
Received: from c60.cesmail.net ([216.154.195.49]:23859 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1AFV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:56:09 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 16:56:09 EST
Message-ID: <4D26381A.8040901@gnu.org>
Date: Thu, 06 Jan 2011 16:46:02 -0500
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
References: <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au>
In-Reply-To: <20110106211645.GA26184@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 04:16 PM, Herbert Xu wrote:

> This is also why only hash and skcipher are supported as they
> are the main algorithm types supported by teh current async
> drivers in the kernel.

Are there any chances AEAD will be supported?  Is the API extendable to 
allow that?

If I remember correctly, the original patch was simply a port of FreeBSD 
/dev/crypto, which doesn't support AEAD.

-- 
Regards,
Pavel Roskin
