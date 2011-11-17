Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1KQQfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:35:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40327 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1KQQfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:35:41 -0500
Message-ID: <4EC537B1.1000408@zytor.com>
Date: Thu, 17 Nov 2011 08:34:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Fenghua Yu <fenghua.yu@intel.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix typo/thinko in get_random_bytes()
References: <4ec4061010261a4cb0@agluck-desktop.sc.intel.com> <4EC41060.2040501@zytor.com> <alpine.LFD.2.02.1111162039240.4902@ionos>
In-Reply-To: <alpine.LFD.2.02.1111162039240.4902@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 11:41 AM, Thomas Gleixner wrote:
> 
> 
> On Wed, 16 Nov 2011, H. Peter Anvin wrote:
> 
>> On 11/16/2011 10:50 AM, Luck, Tony wrote:
>>> If there is an architecture-specific random number generator we use
>>> it to acquire randomness one "long" at a time. We should put these
>>> random words into consecutive words in the result buffer - not just
>>> overwrite the first word again and again.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>
>> Ouch.  Good catch.  This, I guess, is the downside of doing this only on
>> the kernel paths... made this kind of errors harder to catch.
>>
>> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Applied to x86/urgent... I'll try to get the tip-bot back online today
if I can find the time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

