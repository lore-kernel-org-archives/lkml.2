Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1IAGyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:54:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44112 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1IAGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:54:16 -0400
Message-ID: <4E5F2C1B.1040406@gnutls.org>
Date: Thu, 01 Sep 2011 08:54:19 +0200
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
References: <20110901021534.GA26330@gondor.apana.org.au> <4E5F257F.9060202@gnutls.org> <20110901064319.GB27893@gondor.apana.org.au>
In-Reply-To: <20110901064319.GB27893@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 08:43 AM, Herbert Xu wrote:
> On Thu, Sep 01, 2011 at 08:26:07AM +0200, Nikos Mavrogiannopoulos wrote:
>>
>> Actually this is the reason of the ecb(cipher-null) comparison. To
>> emulate the case of a hardware offload device. I tried to make that
>> clear in the text, but may not be. If you see AF_ALG performs really bad
>> on that case. It performs better when a software or a padlock
>> implementation of AES is involved (which as you say it is a useless
>> use-case).
> It's meaningless because such devices operate at a rate much
> lower than the figures you give.

Have you actually measured that?

