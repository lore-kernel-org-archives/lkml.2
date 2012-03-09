Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2CINlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:41:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab2CINlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:41:22 -0500
Message-ID: <4F5A0876.3060408@redhat.com>
Date: Fri, 09 Mar 2012 08:41:10 -0500
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 3.0.2 (Macintosh/20111203)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: linux-kernel@vger.kernel.org, Paul Wouters <pwouters@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Willi <martin@strongswan.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] xfrm: fix hmac(sha256) truncation length
References: <1331151157-19149-1-git-send-email-jarod@redhat.com> <20120308003741.GA14995@gondor.apana.org.au>
In-Reply-To: <20120308003741.GA14995@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Wed, Mar 07, 2012 at 03:12:37PM -0500, Jarod Wilson wrote:
>> Commit bc74b0c8af17458ecae77f725e507ab5fd100105 added proper hmac sha384
>> and sha512 variants with truncation lengths of 192 and 256 respectively,
>> per RFC4868:
>
> No, it was done deliberately to maintain backwards compatibility.
> Userspace should set the truncbits explicitly from now on.

Okay, I suspected that might be the case. No plans to ever invert that, 
so that userspace has to explicitly set the shorter truncbits for 
backwards compat?

-- 
Jarod Wilson
jarod@redhat.com.


