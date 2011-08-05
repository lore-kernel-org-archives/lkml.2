Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab1HEQ3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:29:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50814 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab1HEQ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:29:42 -0400
Message-ID: <4E3C1A21.1070105@zytor.com>
Date: Fri, 05 Aug 2011 09:28:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v3 0/3] Add support for architectural random number generator
References: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com> <1312147616-29125-1-git-send-email-hpa@zytor.com> <20110805120033.GA3967@gondor.apana.org.au>
In-Reply-To: <20110805120033.GA3967@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 05:00 AM, Herbert Xu wrote:
>>
>> Git tree also available:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-rdrand.git rdrand-3
>>
>> Again, for technical documentation see:
>>
>> http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/
> 
> FWIW these patches look good to me and I'm happy to take them
> if Linus doesn't merge them directly.
> 

Thanks.  I have put them in -tip as well:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-tip.git x86/rdrand

... but if you think there is a more appropriate workflow that would be
good too.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

