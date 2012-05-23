Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2EWRN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:13:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42378 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759404Ab2EWRNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:13:55 -0400
Message-ID: <4FBD1AC8.7020602@zytor.com>
Date: Wed, 23 May 2012 10:13:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
References: <20120523113432.GA12142@gmail.com> <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
In-Reply-To: <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 10:07 AM, Linus Torvalds wrote:
> On Wed, May 23, 2012 at 4:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> Sasha Levin (1):
>>      x86, printk: Add missing KERN_CONT to NMI selftest
> 
> Why? This seems to be garbage.
> 

This was added to the urgent branch earlier (but it wasn't worth pushing
late in rc) but apparently a more underlying bug was fixed in the meantime.

It didn't seem worth removing since the KERN_CONT should really be there
anyway.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

