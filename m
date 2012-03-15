Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161378Ab2COUNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:13:55 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50485 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161335Ab2COUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:13:54 -0400
Message-ID: <20120315220534.81435da1cs6o2fks@www.81.fi>
Date: Thu, 15 Mar 2012 22:05:34 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Mar 15 (crypto)
References: <20120315185935.a0c475a30b2836765273a1e5@canb.auug.org.au>
 <4F620F37.4070404@xenotime.net>
In-Reply-To: <4F620F37.4070404@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Randy Dunlap <rdunlap@xenotime.net>:

> On 03/15/2012 12:59 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> News: the build system (see below) has had its toolchains for most
>> architectures updated to gcc 4.6.3.  People might like to check the build
>> results and consider if this change has caused any problems.  There are
>> also a number of architectures that are building today for the first
>> time.  Thanks to Tony Breeds for his efforts in providing toolchains.
>>
>> Changes since 20120314:
>
>
> on x86_64:
>
> arch/x86/crypto/twofish-x86_64-3way.o: In function `fini':
> (.exit.text+0x0): multiple definition of `fini'
> arch/x86/crypto/camellia-x86_64.o:(.exit.text+0x0): first defined here
> arch/x86/crypto/twofish-x86_64-3way.o: In function `init':
> (.init.text+0x0): multiple definition of `init'
> arch/x86/crypto/camellia-x86_64.o:(.init.text+0x0): first defined here
>

Ah.. init()/fini() should be static functions but are not. I'll send  
patches soon. Thanks.

>
> Full randconfig file is attached.
>
>
> --
> ~Randy
>



