Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030910Ab2CVVS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:18:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2CVVSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:18:21 -0400
Message-ID: <4F6B9709.1040701@zytor.com>
Date: Thu, 22 Mar 2012 14:18:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: camellia-x86_64 - module init/exit functions
 should be static
References: <4F620F37.4070404@xenotime.net> <20120315201151.11667.63183.stgit@localhost6.localdomain6> <4F6A74E3.7080901@xenotime.net> <20120322004646.GA8489@gondor.apana.org.au>
In-Reply-To: <20120322004646.GA8489@gondor.apana.org.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 05:46 PM, Herbert Xu wrote:
> On Wed, Mar 21, 2012 at 05:40:03PM -0700, Randy Dunlap wrote:
>> On 03/15/2012 01:11 PM, Jussi Kivilinna wrote:
>>
>>> This caused conflict with twofish-x86_64-3way when compiled into kernel,
>>> same function names and not static.
>>
>> Have these patches been merged anywhere?
>> I'm still seeing build problems in linux-next 20120321.
> 
> Thanks for the reminder, I'll push these through today.

Please push these to Linus ASAP, it is breaking the x86-64 allyesconfig
build upstream right now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

