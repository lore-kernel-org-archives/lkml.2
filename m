Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab2EWQbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:31:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab2EWQbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:31:33 -0400
Message-ID: <4FBD10D5.6080602@zytor.com>
Date: Wed, 23 May 2012 09:31:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
References: <1337684026-19740-1-git-send-email-bp@amd64.org>  <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>  <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>  <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop>
In-Reply-To: <1337790571.9783.28.camel@laptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Actually we need a BIT() macro that works both
>> on 32- and 64-bit. But that won't be that easy:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1010.1/02335.html
>>
>> And it should return UL for shift values < 32 and ULL otherwise.
> 

Why do you want that behavior?  That seems bizarre...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

