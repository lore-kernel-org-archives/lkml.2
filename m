Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2JCHRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:17:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52105 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab2JCHRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:17:38 -0400
Message-ID: <506BE68E.5000004@pobox.com>
Date: Wed, 03 Oct 2012 03:17:34 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
References: <20121003054542.GA2416@havoc.gtf.org> <20121003.020619.772556428995851933.davem@davemloft.net> <506BE0E7.1070701@pobox.com> <20121003071119.GA2571@gondor.apana.org.au>
In-Reply-To: <20121003071119.GA2571@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 03:11 AM, Herbert Xu wrote:
> On Wed, Oct 03, 2012 at 02:53:27AM -0400, Jeff Garzik wrote:
>>
>> Maybe my patch is the best we can do in the current kernel, if
>> dynamic digest size is not currently possible. Register "sha3_224",
>> "sha3_256", ... as you describe, and wait for actual users to appear
>> with unsupported digest sizes.
>
> Let's see what people use before we do anything more fancy.
>
> If the variants really start proliferating, we can add a template
> called "trunc" and then have things like "trunc(sha3,224)", etc.

If they start proliferating, you really just want a single "sha3(n)", 
one single shash_alg registered at driver init time.

	Jeff




